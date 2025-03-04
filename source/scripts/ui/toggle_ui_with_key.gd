extends CanvasLayer

@export var key : String
@export var pause_menu : bool
@export var default_focus : Control

func _ready():
	if pause_menu:
		connect("visibility_changed", _on_visiblity_changed)

func _input(event):
	if event.is_action_pressed(key):
		visible = !visible
		if default_focus != null:
			default_focus.grab_focus()

func _on_visiblity_changed():
	GameManager.paused = visible
