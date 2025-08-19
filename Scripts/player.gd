extends CharacterBody2D

#@onready var animated_sprite_2d: Animatedsprite2D = $Animatedsprite2D

const GRAVITY : int = 3200
const JUMP_SPEED : int = -1300
const MOVE_SPEED : int = 2000
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	velocity.x = 0
	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("idle")
		#else:
			if Input.is_action_pressed("jump"):
				velocity.y = JUMP_SPEED
				#$JumpSound.play()
			elif Input.is_action_pressed("right"):
				velocity.x = MOVE_SPEED
				$AnimatedSprite2D.play("run")
			#else:
			#	$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")
		
#func _set_animation():
	
		
	move_and_slide()
	
	print(GameManager.coins)
	print(GameManager.key)
