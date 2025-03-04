extends Node

@export var main_menu : bool
@export var focus : Control

func _ready():
	GameManager.main_menu = main_menu
	if main_menu:
		GameManager.paused = false
		if has_node("SubViewportContainer/SubViewport"):
			UIManager.current_viewport = $SubViewportContainer/SubViewport
	if focus != null:
		focus.grab_focus()
