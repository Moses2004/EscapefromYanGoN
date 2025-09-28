extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_jump: AudioStreamPlayer = $sfx_jump

const GRAVITY = 1700
const SPEED = 650

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

func player_falling(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func player_idle(_delta):
	if is_on_floor():
		current_state = State.Idle

func player_run(_delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction != 0:
		current_state = State.Run
		animated_sprite_2d.flip_h = false if direction > 0 else true

func player_jump(delta):
	if Input.is_action_just_pressed("jump"):
		sfx_jump.play()
		velocity.y = -1000
		current_state = State.Jump
	if !is_on_floor() and current_state == State.Jump:
		var direction = Input.get_axis("left", "right")
		velocity.x += direction * 100 * delta
		
func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")

# --- Key pickup ---
func _on_key_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Key"):
		GameManager.key += 1
		body.queue_free()

# --- Door logic (Step2 -> Step3) ---
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
		elif current_scene.ends_with("res://Scenes/step3.tscn"):
			get_tree().change_scene_to_file("res://Scenes/the_ending.tscn")
		else:
			print("⚠️ No matching next step for: ", current_scene)
	else:
		print("You need 3 keys to open this door!")
