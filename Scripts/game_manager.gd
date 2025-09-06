extends Node

var coins: int = 0
var key: int = 0
var score: int = 0

func _process(delta: float) -> void:
	# get the HUD node (adjust path if needed)
	var hud = get_tree().root.get_node("HUD")

	if hud:
		var coins_label = hud.get_node("CoinsValue")
		var key_label = hud.get_node("KeyLabel")

		if coins_label:
			coins_label.text = str(coins)
		if key_label:
			key_label.text = str(key)
