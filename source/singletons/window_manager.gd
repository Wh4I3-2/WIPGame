extends Node

var fullscreen = false : set = _set_fullscreen, get = _get_fullscreen
var focused = true

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	SettingsManager.setting_changed.connect(_on_setting_changed)
	
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	
	fullscreen = SettingsManager.get_setting("video/fullscreen")

func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		focused = false
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
		focused = true

func _input(event):
	if event.is_action_pressed("fullscreen"):
		toggle_fullscreen()
	if event.is_action_pressed("screenshot"):
		screenshot()

func screenshot():
	var capture = get_viewport().get_texture().get_image()
	
	var _time = Time.get_datetime_string_from_system().replace(":", "-")
	
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("user://Screenshots/")):
		DirAccess.make_dir_absolute(ProjectSettings.globalize_path("user://Screenshots/"))
	
	var filename = "user://Screenshots/%s.png" % _time
	
	capture.save_png(filename)

func toggle_fullscreen():
	fullscreen = !fullscreen

func _set_fullscreen(new_value):
	fullscreen = new_value
	
	if fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	SettingsManager.set_setting("video/fullscreen", fullscreen, self)

func _get_fullscreen():
	return fullscreen

func _on_setting_changed(path, value, setter):
	if setter == self: return
	if path == "video/fullscreen":
		fullscreen = value
