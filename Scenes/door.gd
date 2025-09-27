extends Area2D

@export_file("*.tscn") var next_level_path: String  # set in Inspector

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):   # ✅ only the player
		if GameManager.key >= 3:     # ✅ requires 3 keys
			$DoorAnimation.play("Open")
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file(next_level_path)
		else:
			print("You need 3 keys to open this door!")
