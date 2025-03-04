class_name CosmeticButton
extends ButtonPlus

enum CosmeticTypes {
	HAT
}

static var cosmetic_types_settings: Dictionary = {
	CosmeticTypes.HAT: "cosmetic/hat"
}

@export_group("Settings")
@export var type: CosmeticTypes = CosmeticTypes.HAT

var _seperation = 0.0

func _ready():
	connect("button_up", on_button_up)
	connect("button_up", _button_up_sound)
	focus_entered.connect(_play_focus_sound)
	SettingsManager.setting_changed.connect(_on_setting_changed)
	
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
	else:
		_seperation = lerp(_seperation, 0.0, delta * speed)
	if seperator == null: return
	seperator.remove_theme_constant_override("seperation")
	seperator.add_theme_constant_override("separation", _seperation)

func _on_setting_changed(path, value, setter):
	if setter == self: return
	if path != cosmetic_types_settings[type]: return
	button_pressed = value == icon.resource_path

func on_button_up():
	SettingsManager.set_setting(cosmetic_types_settings[type], icon.resource_path, self)
	print(icon.resource_path)

func on_value_changed():
	pass
