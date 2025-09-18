extends Control

@onready var click_button: AudioStreamPlayer = $ClickButton
@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options

func _ready():
	main_buttons.visible = true
	options.visible = false

func _process(_delta: float):
	pass

func _on_start_pressed() -> void:
	click_button.play()
	get_tree().change_scene_to_file("res://Scenes/story_intro.tscn")

func _on_setting_pressed() -> void:
	click_button.play()
	print("setting pressed")
	main_buttons.visible = false
	options.visible = true

func _on_exit_pressed() -> void:
	click_button.play()
	get_tree().quit()
	
func _on_back_options_pressed() -> void:
	click_button.play()
	_ready()
