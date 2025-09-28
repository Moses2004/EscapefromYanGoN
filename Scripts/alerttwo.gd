extends Node2D

@onready var click_button: AudioStreamPlayer = $ClickButton

func _ready():
	# Connect each button's pressed signal to a function
	$Panel/Step1Button.pressed.connect(_on_step1_pressed)


# Each function changes to a different level
func _on_step1_pressed():
	click_button.play()
	get_tree().change_scene_to_file("res://Scenes/step_2.tscn")


func _on_step_1_button_pressed():
	click_button.play()
	# Load the main game scene from its file path
	var game_scene = "res://Scenes/step_2.tscn"
	# Tell the SceneTree to change to the new scene
	get_tree().change_scene_to_file(game_scene)
