extends CanvasLayer

func _ready():
	SettingsManager.setting_changed.connect(_on_setting_changed)
	visible = !SettingsManager.get_setting("video/disable_noise")

func _on_setting_changed(path, value, _setter):
	if path != "video/disable_noise": return
	visible = !value
