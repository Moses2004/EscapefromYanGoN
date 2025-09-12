extends Control

# === Editable in Inspector ===
@export var typing_speed := 0.035
@export var skip_to_scene := "res://scenes/MainGame.tscn"  # set your main game scene

# === Story pages ===
@export var dialog_pages := [
	"Yangon... once a city of lights, laughter, and endless noise.\nNow, it is nothing but broken streets and the sound of the undead.",
	"When the outbreak began, I was away...\nBy the time I returned, everything was gone.\nMy home... my people... my family.",
	"I don’t know if they are alive, or if they’ve already become part of the horde.\nBut I will not stop until I find out.",
	"Every step through this city is a fight for survival.\nZombies lurk in every alley.\nBut fear will not control me.",
	"I am the hunter.\nThis is my city.\nAnd I will find my family... or die trying."
]

# === Internal state ===
var current_page := 0
var typing_text := ""
var typing_index := 0
var typing_accum := 0.0
var is_typing := false

# === Node references ===
@onready var dialog_label : Label = $DialogPanel/VBoxContainer/dialog_label
@onready var next_button : Button = $button_row/next_button   # updated path
@onready var skip_button : Button = $button_row/skip_button   # updated path
@onready var fade_rect : ColorRect = $FadeRect

# === Ready ===
func _ready():
	# connect buttons
	next_button.pressed.connect(_on_next_pressed)
	skip_button.pressed.connect(_on_skip_pressed)

	# fade in
	fade_rect.color = Color(0, 0, 0, 1.0)
	var t = create_tween()
	t.tween_property(fade_rect, "color", Color(0, 0, 0, 0), 0.45)

	# show first page
	_show_page(current_page)

# === Show a page with typing effect ===
func _show_page(page_index: int) -> void:
	if page_index < 0 or page_index >= dialog_pages.size():
		return
	typing_text = dialog_pages[page_index]
	dialog_label.text = ""
	typing_index = 0
	typing_accum = 0.0
	is_typing = true

# === Typing effect ===
func _process(delta: float) -> void:
	if is_typing:
		typing_accum += delta
		while typing_accum >= typing_speed and is_typing:
			typing_accum -= typing_speed
			if typing_index < typing_text.length():
				dialog_label.text += typing_text[typing_index]
				typing_index += 1
			else:
				is_typing = false
				dialog_label.text = typing_text
				break

# === Keyboard shortcuts ===
func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_next_pressed()
	elif event.is_action_pressed("ui_cancel"):
		_on_skip_pressed()

# === Next button ===
func _on_next_pressed() -> void:
	if is_typing:
		dialog_label.text = typing_text
		is_typing = false
	else:
		current_page += 1
		if current_page < dialog_pages.size():
			_page_transition_then_show(current_page)
		else:
			_start_game()

# === Skip button ===
func _on_skip_pressed() -> void:
	_start_game()

# === Page transition flash ===
func _page_transition_then_show(next_page: int) -> void:
	fade_rect.color = Color(0, 0, 0, 0)
	var tween = create_tween()
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 0.8), 0.12)
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 0), 0.12)
	await get_tree().create_timer(0.24).timeout
	_show_page(next_page)

# === Fade out and start game ===
func _start_game() -> void:
	next_button.disabled = true
	skip_button.disabled = true

	var fade_time := 0.45
	var t = create_tween()
	t.tween_property(fade_rect, "color", Color(0, 0, 0, 1.0), fade_time)
	await get_tree().create_timer(fade_time).timeout

	var err = get_tree().change_scene_to_file(skip_to_scene)
	if err != OK:
		push_error("Failed to load main scene: %s" % skip_to_scene)
