extends CanvasLayer

func _process(delta: float) -> void:
	$CoinsValue.text = str(GameManager.coins)
	$KeyLabel.text = str(GameManager.key)
