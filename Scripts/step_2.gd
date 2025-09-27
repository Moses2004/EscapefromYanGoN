extends Node

@onready var animated_sprite = $Player/AnimatedSprite2D
@onready var coins
@onready var keys

# preload obstacles
var rock_scene = preload("res://Scenes/rock.tscn")
var stone_scene = preload("res://Scenes/stone.tscn")
var zombie1_scene = preload("res://Scenes/zombie1.tscn")
var zombie2_scene = preload("res://Scenes/zombie2.tscn")
var zombie3_scene = preload("res://Scenes/zombie3.tscn")
var obstacle_types := [rock_scene, stone_scene, zombie1_scene, zombie2_scene, zombie3_scene]
var obstacles: Array = []
var last_obs: Node2D = null

const PLAYER_START_POS := Vector2(-71, 124)
const CAM_START_POS := Vector2(578, 321)
var difficulty: int
const MAX_DIFFICULTY: int = 2
var score: float
var speed: float
const START_SPEED: float = 10.0
const MAX_SPEED: float = 30.0
const SPEED_MODIFIER: float = 5000.0
var screen_size: Vector2i
var ground_height: int
var game_running: bool

# Spawn timing
var time_since_last_spawn: float = 0.0
var spawn_interval: float = 2.0

func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Road/Sprite2D.texture.get_height()
	$RESTART/VBoxContainer/Button3/Button.pressed.connect(new_game)
	$RESTART/VBoxContainer/Button3/Home.pressed.connect(_on_home_pressed)
	new_game()
	
func _on_home_pressed() -> void:
	get_tree().paused = false   # unpause in case game was paused
	get_tree().change_scene_to_file("res://main-menu/interactive-map/map.tscn")

func new_game() -> void:
	score = 0
	coins = 0
	keys = 0
	GameManager.coins = 0     # reset global coins
	GameManager.score = 0     # reset global score if needed
	GameManager.key = 0		# reset gobba key
	game_running = false
	get_tree().paused = false
	difficulty = 0
	
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2(0, 0)
	
	$Road.position = Vector2(0, 0)
	$RESTART.hide()


func _process(_delta: float) -> void:
	if Input.is_action_pressed("right"):
		game_running = true
	else:
		game_running = false

	if game_running:
		# Update speed based on score
		speed = START_SPEED + (score / SPEED_MODIFIER)
		speed = clamp(speed, START_SPEED, MAX_SPEED)

		# Move player with delta
		$Player.position.x += speed * _delta

		# Update score based on movement
		score += speed * _delta

		# Spawn obstacles based on time
		time_since_last_spawn += _delta
		if time_since_last_spawn >= spawn_interval:
			generate_obs()
			time_since_last_spawn = 0.0

		# Update ground position
		if $Player.position.x - $Road.position.x > screen_size.x * 1.5:
			$Road.position.x += screen_size.x
		elif $Player.position.x - $Road.position.x < -screen_size.x * 0.5:
			$Road.position.x -= screen_size.x

		# Clean up obstacles behind player
		for obs in obstacles:
			if obs.position.x < ($Player.position.x - screen_size.x):
				remove_obs(obs)

	show_score()

func generate_obs() -> void:
	var obs_type = obstacle_types[randi() % obstacle_types.size()]
	var max_obs = difficulty + 1
	for i in range(randi() % max_obs + 1):
		var obs = obs_type.instantiate()
		var sprite = obs.get_node("Sprite2D")
		var obs_height = sprite.texture.get_height()
		var obs_scale = sprite.scale

		var obs_x: float = $Player.position.x + screen_size.x + (i * 100)
		var ground_y = $Road.position.y
		var obs_y: float = ground_y + (obs_height * obs_scale.y / 2) + 550
		
		last_obs = obs
		add_obs(obs, obs_x, obs_y)

func add_obs(obs: Node2D, x: float, y: float) -> void:
	obs.position = Vector2(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func remove_obs(obs: Node2D) -> void:
	obs.queue_free()
	obstacles.erase(obs)

func hit_obs(body: Node) -> void:
	if body.name == "Player":
		game_over()

func show_score() -> void:
	$HUD/NinePatchRect.get_node("ScoreLabel").text = "SCR: " + str(int(score))
	$HUD/CoinsValue.text = str(GameManager.coins)

func spawn_coin_cluster() -> void:
	var _count = randi_range(4, 8) # unused var fixed
	difficulty = int(score / float(SPEED_MODIFIER))
	difficulty = clamp(difficulty, 0, MAX_DIFFICULTY)

func game_over() -> void:
	if animated_sprite:
		animated_sprite.play("dead")
		get_tree().paused = true
		game_running = false

		# Update final results
		$RESTART/VBoxContainer/Button2.text = "Final Score: " + str(int(score))
		$RESTART/VBoxContainer/Button3.text = "Total Coins: " + str(GameManager.coins)

		$RESTART.show()
	else:
		print("Error: AnimatedSprite2D is null!")
