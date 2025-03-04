extends ButtonPlus

@export_category("UI Button")
@export var ui : Node
@export var _hide : bool

func on_button_up():
	if UIManager.current != null:
		UIManager.current.visible = false
	ui.visible = !_hide
	if ui is UIMenu:
		if ui.pause_menu == true:
			GameManager.paused = !_hide
