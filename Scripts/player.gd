extends CharacterBody2D

const move_speed = 200.0
const GRAVITY: int = 4200
const JUMP_SPEED: int = -1200
var direction = Vector2.ZERO

func _process(delta):
	var horizontal_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.y += GRAVITY * delta
	# Add the gravity

	if !is_on_floor():
			$AnimatedSprite2D.play("jump")
	elif horizontal_input != 0:
			$AnimatedSprite2D.play("run")
			$AnimatedSprite2D.flip_h = horizontal_input < 0
	elif Input.is_action_just_pressed("jump"):
			$AnimatedSprite2D.play("jump")
			velocity.y = JUMP_SPEED
	else:
			$AnimatedSprite2D.play("idle")
	
	
func _physics_process(delta):
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = direction.x * move_speed
		
	move_and_slide()
