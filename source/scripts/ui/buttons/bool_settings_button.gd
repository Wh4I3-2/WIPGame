extends SettingsButton

@export var checkbox : CheckBox

func on_button_up():
	value = !value
	SettingsManager.set_setting(setting, value, self)

func on_value_changed():
	if value == null:
		return
	if checkbox != null:
		checkbox.button_pressed = value
