extends Node

@onready var animated_sprite = $Player/AnimatedSprite2D
@onready var coins

#var car = preload("res://Scenes/car.tscn")

#preload obstacles
var rock_scene = preload("res://Scenes/rock.tscn")
var stone_scene = preload("res://Scenes/stone.tscn")
var zombie1_scene = preload("res://Scenes/zombie1.tscn")
var zombie2_scene = preload("res://Scenes/zombie2.tscn")
var zombie3_scene = preload("res://Scenes/zombie3.tscn")
var obstacle_types := [rock_scene, stone_scene, zombie1_scene,zombie2_scene,zombie3_scene]
var obstacles : Array
var last_obs : Node2D = null


const PLAYER_START_POS := Vector2(-71, 124)  # Changed Vector2i to Vector2
const CAM_START_POS := Vector2(578, 321)
var difficulty
const MAX_DIFFICULTY : int = 2
var score : int
var speed : float
const START_SPEED : float = 7
const MAX_SPEED : int = 25
const SPEED_MODIFIER : int = 5000
var screen_size : Vector2i
var ground_height : int 
var game_running : bool






# Spawn timing
var time_since_last_spawn = 0.0
var spawn_interval = 2.0  # You can randomize this too


func _ready():
	screen_size = get_window().size
	ground_height = $Road/Sprite2D.texture.get_height()
	$RESTART/VBoxContainer/Button.pressed.connect(new_game)
	
	new_game()
	
	

func new_game():
	score = 0
	coins = 0
	game_running = false
	get_tree().paused = false
	difficulty = 0
	
	
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2(0, 0)  # Changed Vector2i to Vector2
	$Camera2D.position = CAM_START_POS
	$Road.position = Vector2(0, 0)
	
	$RESTART.hide()

func _process(delta):
	if Input.is_action_pressed("right"):
		game_running = true
	else:
		game_running = false

	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		
		$Player.position.x += speed
		$Camera2D.position.x += speed
		score += speed
		
		generate_obs()

		# Update ground position
		if $Camera2D.position.x - $Road.position.x > screen_size.x * 1.5:
			$Road.position.x += screen_size.x
			
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
		
			
	
	show_score()
	
func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var max_obs = difficulty + 1
		for i in range(randi() % max_obs + 1):
			var obs = obs_type.instantiate()
			var sprite = obs.get_node("Sprite2D")
			var obs_height = sprite.texture.get_height()
			var obs_scale = sprite.scale

			var obs_x : int = screen_size.x + score + 100 + (i * 100)

			# ✅ Use ground position, not screen_size
			var ground_y = $Road.position.y
			var obs_y : int = ground_y + (obs_height * obs_scale.y / 2) + 500
			
			last_obs = obs
			add_obs(obs, obs_x, obs_y)

func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)
	
func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)
	
func hit_obs(body):
	if body.name == "Player":
		game_over()


func show_score():
	$HUD/NinePatchRect.get_node("ScoreLabel").text = "SCR: " + str(score)
	$HUD/CoinsValue.text = "0"
	


func spawn_coin_cluster():
	var count = randi_range(4, 8)
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY
		
func game_over():
	if animated_sprite:
		animated_sprite.play("dead")
		get_tree().paused = true
		game_running = false
		$RESTART.show()
	else:
		print("Error: AnimatedSprite2D is null!")
