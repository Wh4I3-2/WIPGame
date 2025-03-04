class_name SettingsButton
extends ButtonPlus

@export_group("Settings")
@export var setting : String

var _seperation = 0.0
var _start_text = ""
var value = null : set = _set_value

func _ready():
	_start_text = text
	connect("button_up", on_button_up)
	connect("button_up", _button_up_sound)
	focus_entered.connect(_play_focus_sound)
	SettingsManager.setting_changed.connect(_on_setting_changed)
	value = SettingsManager.get_setting(setting)
	
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	if is_hovered():
		if has_hovered == false:
			_play_focus_sound()
			has_hovered = true
	else:
		has_hovered = false
	if has_focus() or is_hovered():
		_seperation = lerp(_seperation, selected_seperation, delta * speed)
		text = _start_text + " <"
	else:
		_seperation = lerp(_seperation, 0.0, delta * speed)
		text = _start_text
	if seperator == null: return
	seperator.remove_theme_constant_override("seperation")
	seperator.add_theme_constant_override("separation", _seperation)

func _on_setting_changed(path, _value, setter):
	if setter == self: return
	if path != setting: return
	value = _value

func _set_value(new_value):
	value = new_value
	_play_focus_sound()
	on_value_changed()

func on_value_changed():
	pass
