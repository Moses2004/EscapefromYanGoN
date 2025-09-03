extends Node2D

func _ready():
	# Connect each button's pressed signal to a function
	$Step1Button.pressed.connect(_on_step1_pressed)
	$Step2Button.pressed.connect(_on_step2_pressed)
	$Step3Button.pressed.connect(_on_step3_pressed)
	$Step4Button.pressed.connect(_on_step4_pressed)
	$Step5Button.pressed.connect(_on_step5_pressed)


# Each function changes to a different level
func _on_step1_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_step2_pressed():
	get_tree().change_scene_to_file("res://interactive-map/level_2.tscn")

func _on_step3_pressed():
	get_tree().change_scene_to_file("res://interactive-map/level_3.tscn")

func _on_step4_pressed():
	get_tree().change_scene_to_file("res://interactive-map/level_4.tscn")

func _on_step5_pressed():
	get_tree().change_scene_to_file("res://interactive-map/level_5.tscn")

func _on_step_1_button_pressed():
	# Load the main game scene from its file path
	var game_scene = "res://main.tscn"
	# Tell the SceneTree to change to the new scene
	get_tree().change_scene_to_file(game_scene)
