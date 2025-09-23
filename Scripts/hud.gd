extends CanvasLayer

@onready var coins_value = $CoinsValue
@onready var key_label = $KeyLabel
@onready var pause_button = $PauseButton
@onready var pause_menu = $PauseMenu
@onready var resume_button = $PauseMenu/ResumeButton
@onready var quit_button = $PauseMenu/QuitButton
@onready var back_to_menu_button = $PauseMenu/BackToMenuButton
@onready var restart_button = $PauseMenu/RestartButton   # 👈 added
@onready var pause_overlay = $PauseOverlay

func _ready() -> void:
	# Connect button signals
	pause_button.pressed.connect(_on_pause_pressed)
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	back_to_menu_button.pressed.connect(_on_back_to_menu_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)   # 👈 connect restart

	# Hide pause menu + overlay at start
	pause_menu.visible = false
	pause_overlay.visible = false

func _process(_delta: float) -> void:
	$CoinsValue.text = str(GameManager.coins)
	$KeyLabel.text = str(GameManager.key)

# Handle ESC key
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			_on_resume_pressed()
		else:
			_on_pause_pressed()

# Pause button
func _on_pause_pressed() -> void:
	get_tree().paused = true
	pause_menu.visible = true
	pause_overlay.visible = true
	pause_button.disabled = true

# Resume button
func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	pause_overlay.visible = false
	pause_button.disabled = false

# Quit button
func _on_quit_pressed() -> void:
	get_tree().quit()

# Back to Menu button
func _on_back_to_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main-menu/main_menu.tscn")  # Update path if needed

# Restart button
func _on_restart_button_pressed() -> void:
	get_tree().paused = false  # unpause before restarting
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()  # reloads the active scene
