extends CharacterBody2D

var speed := 300
var screen_width : int = 1000

func _ready() -> void:
	# Try to find the Hitbox node first
	var hitbox = get_node_or_null("CAR")
	if hitbox:
		hitbox.body_entered.connect(_on_hitbox_body_entered)
	else:
		push_warning("CAR node not found — collision won't trigger!")

func _physics_process(delta: float) -> void:
	velocity.x = -speed
	move_and_slide()

	# Remove if far off-screen
	if position.x < -screen_width:
		queue_free()

func _on_hitbox_body_entered(body: Node) -> void:
	if body.name == "Player":
		print("Collision")
