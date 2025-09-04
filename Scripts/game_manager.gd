extends Node

var coins: int = 0
var key: int = 0
var score: int = 0

func _process(delta: float) -> void:
	var hud = get_tree().root.get_node("HUD/CoinsValue") # adjust path!
	if hud:
		hud.text = str(coins)
