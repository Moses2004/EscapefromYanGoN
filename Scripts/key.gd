extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.key += 1
		GameManager.score += 100
		animation_player.play("pickup")
