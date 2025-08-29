extends Node2D

const MAX_COINS := 1000
const COIN_SCENE := preload("res://Scenes/Coin.tscn")

var coins: Array = []

func _process(_delta):
	while coins.size() < MAX_COINS:
		spawn_pattern()

# ---- PATTERNS ----
func spawn_pattern():
	var choice = randi() % 3
	match choice:
		0: spawn_row()
		1: spawn_arc()
		2: spawn_cluster()

func spawn_row():
	var start_x = global_position.x + randi_range(300, 600)
	var y = 400 + randi_range(-100, 100)
	for i in range(randi_range(5, 10)):
		if coins.size() >= MAX_COINS: return
		add_coin(Vector2(start_x + i * 50, y))

func spawn_arc():
	var start_x = global_position.x + randi_range(300, 600)
	var center_y = 400
	var radius = 100
	var count = randi_range(6, 12)
	for i in range(count):
		if coins.size() >= MAX_COINS: return
		var angle = lerp(0.0, PI, float(i) / count)
		add_coin(Vector2(start_x + i * 40, center_y + sin(angle) * radius))

func spawn_cluster():
	var center_x = global_position.x + randi_range(300, 600)
	var center_y = 400 + randi_range(-50, 50)
	for i in range(randi_range(4, 8)):
		if coins.size() >= MAX_COINS: return
		add_coin(Vector2(center_x + randi_range(-40, 40), center_y + randi_range(-40, 40)))

# ---- HELPERS ----
func add_coin(pos: Vector2):
	var coin = COIN_SCENE.instantiate()
	coin.position = pos
	add_child(coin)
	coins.append(coin)
	coin.tree_exited.connect(func(): coins.erase(coin))
