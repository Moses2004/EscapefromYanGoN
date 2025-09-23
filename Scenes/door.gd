extends Area2D


func _on_player_dooropen() -> void:
	$DoorAnimation.play("Open")
	await get_tree().create_timer(0.5).timeout
	$DoorAnimation.play("Close")
