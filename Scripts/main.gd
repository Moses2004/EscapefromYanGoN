extends Node

# Preload zombie scenes
const PLAYER_START_POS := Vector2i(-71, 124)
const CAM_START_POS := Vector2i(578, 321)
var score : int
var speed : int = 4
const START_SPEED : int = 2
var screen_size : Vector2i
var game_running : bool
var zombie1_scene = preload("res://Scenes/zombie1.tscn")
var zombie2_scene = preload("res://Scenes/zombie2.tscn")
var zombie3_scene = preload("res://Scenes/zombie3.tscn")
var zombie4_scene = preload("res://Scenes/zombie4.tscn")
var zombie5_scene = preload("res://Scenes/zombie5.tscn")

# Array of all zombie scenes
var zombie_types := [zombie1_scene, zombie2_scene, zombie3_scene, zombie4_scene, zombie5_scene]

# Spawn timing
var time_since_last_spawn = 0.0
var spawn_interval = 2.0  # You can randomize this too

# Game-related


func _ready():
	randomize() 
	screen_size = get_window().size
	new_game()

func new_game():
	score = 0
	game_running = false
	
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Road.position = Vector2i(0, 0)
	
func _process(delta):
	if Input.is_action_pressed("right"):
		game_running = true
	else:
		game_running = false

	if game_running:
		$Player.position.x += speed
		$Camera2D.position.x += speed
		score += speed

		# Move road
		if $Camera2D.position.x - $Road.position.x > screen_size.x * 1.5:
			$Road.position.x += screen_size.x

		# 🔁 Zombie spawn logic (runs when game is running)
		time_since_last_spawn += delta
		if time_since_last_spawn >= spawn_interval:
			spawn_zombie()
			time_since_last_spawn = 0.0
			# Optional: randomize interval slightly
			spawn_interval = randf_range(1.5, 3.0)

	show_score()


func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score)
	
func spawn_zombie():
	var zombie_scene = zombie_types[randi() % zombie_types.size()]
	var zombie = zombie_scene.instantiate()

	# 🧠 Spawn in front of camera (offscreen right)
	var spawn_x = $Camera2D.position.x + screen_size.x + 100
	var spawn_y = 500  # Replace with the correct ground Y position
	zombie.position = Vector2(spawn_x, spawn_y)
	
	# Add this line to scale the zombie
	# Adjust the Vector2 values (e.g., Vector2(0.8, 0.8)) to match your player's size
	zombie.scale = Vector2(1.8, 1.8) 
	
	add_child(zombie)
