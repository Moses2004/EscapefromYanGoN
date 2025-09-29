extends Control

# === Editable in Inspector ===
@export var typing_speed := 0.035
@export var skip_to_scene := "res://main-menu/main_menu.tscn"  # 👈 go to ending after Step 2
@onready var click_button: AudioStreamPlayer = $ClickButton

# === Story pages for Step 2 ===
@export var dialog_pages := [
	"After countless battles, Yangon finally grows silent.",
	"My strength is almost gone... yet my heart is full.",
	"Through the smoke and ruins... I see them.",
	"My family. Alive. Waiting for me.",
	"Tears fall, but they are tears of joy.",
	"We are together again... no more fear, no more running.",
	"The nightmare is over.",
	"The End. Be happy with your family — a new life begins."
]



# === Internal state ===
var current_page := 0
var typing_text := ""
var typing_index := 0
var typing_accum := 0.0
var is_typing := false

# === Node references ===
@onready var dialog_label : Label = $DialogPanel/VBoxContainer/dialog_label
@onready var next_button : Button = $button_row/next_button
@onready var skip_button : Button = $button_row/skip_button
@onready var fade_rect : ColorRect = $FadeRect

# === Ready ===
func _ready():
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
	click_button.play()
	if is_typing:
		dialog_label.text = typing_text
		is_typing = false
	else:
		current_page += 1
		if current_page < dialog_pages.size():
			_page_transition_then_show(current_page)
		else:
			_on_skip_pressed()

# === Skip button ===
func _on_skip_pressed() -> void:
	click_button.play()
	get_tree().change_scene_to_file(skip_to_scene)

# === Page transition flash ===
func _page_transition_then_show(next_page: int) -> void:
	fade_rect.color = Color(0, 0, 0, 0)
	var tween = create_tween()
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 0.8), 0.12)
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 0), 0.12)
	await get_tree().create_timer(0.24).timeout
	_show_page(next_page)
