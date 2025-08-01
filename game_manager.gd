extends Node

var coins = 0
var score = 0

func _process(delta: float) -> void:
	$"HUD/CoinsValue".text = str(coins)
