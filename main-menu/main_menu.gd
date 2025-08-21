extends Control

func _ready():
	pass

func _process(_delta: float):
	pass

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://main-menu/interactive-map/map.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
