extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_jump: AudioStreamPlayer = $sfx_jump

const GRAVITY = 1700
const SPEED = 650
const JUMP_FORCE = -650

var jump_count = 0
var max_jumps = 2  # 1 = single jump, 2 = double jump

var key = false
signal dooropen
enum State {Idle, Run, Jump}

var current_state

func _ready():
	current_state = State.Idle

func _physics_process(delta):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta) 
	move_and_slide()
	player_animations()

# --- Gravity + reset jump ---
func player_falling(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		jump_count = 0  # ✅ Reset jump when landing

# --- Idle ---
func player_idle(_delta):
	if is_on_floor() and velocity.x == 0:
		current_state = State.Idle

# --- Run ---
func player_run(_delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction != 0:
		current_state = State.Run
		animated_sprite_2d.flip_h = direction < 0

# --- Jump (single or double) ---
func player_jump(delta):
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		sfx_jump.play()
		velocity.y = JUMP_FORCE
		current_state = State.Jump
		jump_count += 1  # ✅ Count jumps

# --- Animations ---
func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")

# --- Key pickup ---
func _on_key_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Key"):
		GameManager.key += 1
		body.queue_free()

# --- Door logic 
func _on_door_body_entered(body: Node2D) -> void:
	if GameManager.key >= 3:  # Require 3 keys
		emit_signal("dooropen")
		await get_tree().create_timer(0.5).timeout

		# Find which scene we are currently in
		var current_scene = get_tree().current_scene.scene_file_path

		if current_scene.ends_with("res://Scenes/step1.tscn"):
			get_tree().change_scene_to_file("res://Scenes/Step2Dialogue.tscn")
		elif current_scene.ends_with("res://Scenes/step_2.tscn"):
			get_tree().change_scene_to_file("res://Scenes/Step3Dialouge.tscn")
		elif current_scene.ends_with("res://Scenes/step_3.tscn"):
			get_tree().change_scene_to_file("res://Scenes/the_ending.tscn")
		else:
			print("⚠️ No matching next step for: ", current_scene)
	else:
		print("You need 3 keys to open this door!")
