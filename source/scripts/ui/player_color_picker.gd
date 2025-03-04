extends ColorPicker

@export var setting: String

func _ready() -> void:
	color_changed.connect(_on_color_changed)
	color = Color.html(SettingsManager.get_setting(setting))
	SettingsManager.setting_changed.connect(_on_setting_changed)

func _on_color_changed(_color: Color) -> void:
	SettingsManager.set_setting(setting, color.to_html(), self)

func _on_setting_changed(path, value, setter) -> void:
	if setter == self: return
	if path != setting: return
	color = Color.html(value)
