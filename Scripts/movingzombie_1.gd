extends CharacterBody2D

var movement = Vector2()
var speed = 100

const GRAVITY = 32
const UP = Vector2.UP

func _physics_process(delta):
	move()
	
func move():
	
	movement.y += GRAVITY
	
	movement.x += -speed
	
	move_and_slide()
