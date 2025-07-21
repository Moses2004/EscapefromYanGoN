extends AnimatedSprite2D

# Movement variables
@export var speed: float = 50.0 # Pixels per second
@export var walk_distance: float = 200.0 # How far it walks in one direction
var direction: int = 1 # 1 for right, -1 for left
var initial_x: float # To store the starting X position

# Called when the node enters the scene tree for the first time.
func _ready():
	# Ensure the idle animation plays when the scene starts (briefly)
	play("Idle")
	print("Zombie is ready and playing Idle animation.")

	# Store the initial X position to calculate walk distance
	initial_x = global_position.x
	start_walk() # Start walking immediately

# Called every physics frame (good for movement)
func _physics_process(delta):
	# Calculate the target X position for this frame
	var target_x = global_position.x + (speed * direction * delta)

	# Check if it hits the boundary
	# If moving right (direction = 1) and passed the right boundary
	if direction == 1 and target_x >= initial_x + walk_distance:
		direction = -1 # Turn left
		flip_h = true # Flip the sprite horizontally
		play("Walk") # Ensure walk animation is playing if it wasn't

	# If moving left (direction = -1) and passed the left boundary
	elif direction == -1 and target_x <= initial_x - walk_distance:
		direction = 1 # Turn right
		flip_h = false # Unflip the sprite
		play("Walk") # Ensure walk animation is playing

	# Apply the movement
	position.x += speed * direction * delta

	# Ensure the "Walk" animation is playing while moving
	if animation != "Walk" and animation != "Dead": # Don't override if dying
		play("Walk")


# --- Existing functions (keep these or modify as needed) ---

func get_hurt():
	print("Zombie got hurt!")
	play("Hurt")
	await get_tree().create_timer(0.2).timeout
	if animation != "Dead":
		play("Walk") # Go back to walking after hurt, not idle

func start_attack():
	print("Zombie is attacking!")
	play("Attack")
	await get_tree().create_timer(0.5).timeout
	if animation != "Dead":
		play("Walk") # Go back to walking after attack

# Renamed/removed start_walk and stop_moving_or_attacking
# as movement is now handled continuously in _physics_process
func start_walk():
	# This function is now just for initial setup or explicit calls
	if animation != "Walk":
		play("Walk")


func die():
	print("Zombie died!")
	play("Dead")
	set_physics_process(false) # Stop movement when dead
	stop()
	# Example of self-deletion after a short delay (optional)
	# await get_tree().create_timer(2.0).timeout
	# queue_free()
