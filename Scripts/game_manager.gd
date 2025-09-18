extends Node

var coins: int = 0
var key: int = 0
var score: int = 0

func _ready():
	# Hide HUD when starting (main menu scene)
	var hud = get_tree().root.get_node("HUD")
	if hud:
		hud.hide()

func _process(delta: float) -> void:
	var hud = get_tree().root.get_node("HUD")

	if hud and hud.visible:
		var coins_label = hud.get_node("CoinsValue")
		var key_label = hud.get_node("KeyLabel")

		if coins_label:
			coins_label.text = str(coins)
		if key_label:
			key_label.text = str(key)
