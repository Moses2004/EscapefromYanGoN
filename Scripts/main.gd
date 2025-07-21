extends Node

const PLAYER_START_POS := Vector2i(-71, 124)
const CAM_START_POS := Vector2i(578, 321)
var score : int
var speed : int = 4
const START_SPEED : int = 2
var screen_size : Vector2i
var game_running : bool

func _ready():
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

		# Update ground position
		if $Camera2D.position.x - $Road.position.x > screen_size.x * 1.5:
			$Road.position.x += screen_size.x

	show_score()

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score)
