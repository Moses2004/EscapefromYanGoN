extends CharacterBody2D
class_name Player

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_jump: AudioStreamPlayer = $sfx_jump

const GRAVITY : int = 4200
const JUMP_SPEED : int = -2000
const MOVE_SPEED : int = 80

var key = false
signal dooropen

func _physics_process(delta):
	# Apply gravity
	velocity.y += GRAVITY * delta
	velocity.x = 0
	
	# Movement and jump input
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			sfx_jump.play()
			velocity.y = JUMP_SPEED
			sprite.play("jump")
		elif Input.is_action_pressed("right"):
			velocity.x = MOVE_SPEED
			sprite.flip_h = false
			sprite.play("run")
		elif Input.is_action_pressed("left"):
			velocity.x = -MOVE_SPEED
			sprite.flip_h = true
			sprite.play("run")
		else:
			sprite.play("idle")
	else:
		# In air → show jump if going up, fall if going down
		if velocity.y < 0:
			sprite.play("jump")
		else:
			sprite.play("fall")

	move_and_slide()

	
	print(GameManager.coins)
	print(GameManager.key)

func _on_key_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Key"):  # Make sure it's really a key
		GameManager.key += 1
		body.queue_free()

func _on_door_body_entered(body: Node2D) -> void:
	if GameManager.key >= 3:  # ✅ Require 3 keys
		emit_signal("dooropen")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/World.tscn")
	else:
		print("You need 3 keys to open this door!")
