extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.key += 1
		GameManager.score += 100
		queue_free()
