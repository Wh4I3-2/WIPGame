extends PointLight2D

func _ready():
	SettingsManager.setting_changed.connect(_on_setting_changed)
	shadow_enabled = !SettingsManager.get_setting("video/disable_shadows")

func _on_setting_changed(path, value, _setter):
	if path != "video/disable_shadows": return
	shadow_enabled = !value
