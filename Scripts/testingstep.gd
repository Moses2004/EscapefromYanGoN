extends Node

@onready var animated_sprite = $Player/AnimatedSprite2D
@onready var coins
@onready var keys

# preload obstacles
var movingzombie_scene = preload("res://Scenes/movingzombie1.tscn")
var zombie2_scene = preload("res://Scenes/zombie2.tscn")
var obstacle_types := [movingzombie_scene, zombie2_scene]
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
	$RESTART/VBoxContainer/Button.pressed.connect(new_game)
	new_game()

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
		speed = START_SPEED + (score / SPEED_MODIFIER)
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		
		$Player.position.x += speed
		
		score += speed
		
		generate_obs()

		# Update ground position based on player position
		if $Player.position.x - $Road.position.x > screen_size.x * 1.5:
			$Road.position.x += screen_size.x

		# Clean up obstacles behind player
		for obs in obstacles:
			if obs.position.x < ($Player.position.x - screen_size.x):
				remove_obs(obs)
	
	show_score()

func generate_obs() -> void:
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var max_obs = difficulty + 1
		for i in range(randi() % max_obs + 1):
			var obs = obs_type.instantiate()
			var sprite = obs.get_node("Sprite2D")
			var obs_height = sprite.texture.get_height()
			var obs_scale = sprite.scale

			var obs_x: float = screen_size.x + score + 100 + (i * 100)
			var ground_y = $Road.position.y
			var obs_y: float = ground_y + (obs_height * obs_scale.y / 2) + 550
			
			last_obs = obs
			add_obs(obs, obs_x, obs_y)

func add_obs(obs: Node2D, x: float, y: float) -> void:
	obs.position = Vector2(x, y)

	# Look for a Hitbox Area2D inside the obstacle
	if obs.has_node("Hitbox"):
		var hitbox = obs.get_node("Hitbox") as Area2D
		hitbox.body_entered.connect(hit_obs)

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
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func game_over() -> void:
	if animated_sprite:
		animated_sprite.play("dead")
		get_tree().paused = true
		game_running = false
		$RESTART.show()
	else:
		print("Error: AnimatedSprite2D is null!")
