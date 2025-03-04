extends Node

signal setting_changed(path, value, setter)

const KEYBOARD_ACTIONS : PackedStringArray = [
	"move_left",
	"move_right",
	"move_up",
	"move_down",
	
	"jump",
	"grab",
	
	"fullscreen",
	"pause",
	
	"screenshot"
]

var settings : Dictionary
var default_settings = {
	"controls": {
		"keyboard": null
	},
	"video": {
		"fullscreen": true,
		"disable_noise": false,
		"disable_shadows": false
	},
	"audio": {
		"master_volume": 0.5,
		"music_volume": 1.0,
		"sfx_volume": 1.0,
		"disable_music_glitches": false
	},
	"cosmetic": {
		"hat": "",
		"color": "ffffffff",
		"stamina_color": "ff0000ff"
	},
	"extras": {
		"developer_mode": false
	}
}

func _ready():
	default_settings["controls"]["keyboard"] = InputHelper.serialize_inputs_for_actions(KEYBOARD_ACTIONS)
	
	load_settings()

func load_settings():
	if not FileAccess.file_exists("user://settings.json"):
		settings = default_settings
		save_settings()
	else:
		var file : FileAccess = FileAccess.open("user://settings.json", FileAccess.READ)
		var parsed = JSON.parse_string(file.get_as_text())
		if parsed != null:
			settings = parsed
		file.close()
	
	InputHelper.deserialize_inputs_for_actions(settings["controls"]["keyboard"])

func save_settings():
	settings["controls"]["keyboard"] = InputHelper.serialize_inputs_for_actions(KEYBOARD_ACTIONS)
	
	var file : FileAccess = FileAccess.open("user://settings.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(settings, "	"))
	file.close()

func get_setting(path : String):
	var split_path = path.split("/")
	if settings.has(split_path[0]):
		if settings[split_path[0]].has(split_path[1]):
			return settings[split_path[0]][split_path[1]]
		elif default_settings[split_path[0]].has(split_path[1]):
			settings[split_path[0]][split_path[1]] = default_settings[split_path[0]][split_path[1]]
			return settings[split_path[0]][split_path[1]]
		return null
	else:
		if default_settings.has(split_path[0]):
			print(5)
			settings[split_path[0]] = default_settings[split_path[0]]
			return get_setting(path)
		print(6)

func set_setting(path : String, value, setter):
	var split_path = path.split("/")
	if not settings.has(split_path[0]):
		settings[split_path[0]] = {}
	settings[split_path[0]][split_path[1]] = value
	setting_changed.emit(path, value, setter)
	
	save_settings()
