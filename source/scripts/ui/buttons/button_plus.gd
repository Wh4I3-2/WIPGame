class_name ButtonPlus
extends Button

@export var selected_seperation : float = 16
@export var unselected_seperation : float = 0
@export var seperator : VSeparator
@export var h_seperator : HSeparator
@export var speed : float = 5
@export_enum("Left", "Center", "Right") var align = 0

@onready var focus_sound : AudioStream = load("res://assets/audio/sfx/ui_select.ogg")

var seperation = 0.0
var start_text = ""
var has_hovered = false

func _ready():
	start_text = text
	connect("button_up", on_button_up)
	connect("button_up", _button_up_sound)
	focus_entered.connect(_play_focus_sound)

func _process(delta):
	if is_hovered():
		if has_hovered == false:
			_play_focus_sound()
			has_hovered = true
	else:
		has_hovered = false
	if has_focus() or is_hovered():
		on_process(delta)
		match align:
			0:
				text = start_text + " <"
				seperation = lerp(seperation, selected_seperation, delta * speed)
			1:
				text = "> " + start_text + " <"
			2:
				text = "> " + start_text
				seperation = lerp(seperation, -selected_seperation, delta * speed)
	else:
		seperation = lerp(seperation, unselected_seperation, delta * speed)
		text = start_text
	if seperator != null:
		seperator.remove_theme_constant_override("seperation")
		seperator.add_theme_constant_override("separation", seperation)
	if h_seperator != null:
		h_seperator.remove_theme_constant_override("seperation")
		h_seperator.add_theme_constant_override("separation", seperation)

func _play_focus_sound():
	if GameManager.main_menu == false and GameManager.paused == false:
		return 
	if visible == false:
		return
	if focus_sound != null:
		SoundManager.play_sound(focus_sound, 0.0, 0.0)

func _button_up_sound():
	pass

func on_button_up():
	pass

func on_process(_delta):
	pass
