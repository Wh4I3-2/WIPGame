extends Control

@export var action : String
@export var input_overlay : Control

var prompting = false

func prompt_for_input():
	if prompting: return
	input_overlay.show()
	input_overlay.grab_focus()
	input_overlay.gui_input.connect(_on_overlay_gui_input)
	prompting = true

func _on_overlay_gui_input(event : InputEvent):
	get_viewport().set_input_as_handled()
	
	if event.is_pressed():
		InputHelper.set_keyboard_input_for_action(action, event)
		input_overlay.hide()
		input_overlay.gui_input.disconnect(_on_overlay_gui_input)
		prompting = false
		SettingsManager.save_settings()
