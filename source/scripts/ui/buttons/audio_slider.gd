extends HSlider

@export var bus_name : String
@export var value_label : Label
@export var setting : String

@onready var sound : AudioStream = load("res://assets/audio/sfx/ui_select.ogg")

var bus_index : int
var volume = 0.0 :
	set(new_value):
		volume = new_value
		SoundManager.play_sound(sound, 0.0, + volume / 2.0 - 0.25)
		SettingsManager.set_setting(setting, volume, self)
		update_label()
	get:
		return volume

func _ready():
	value_changed.connect(_on_value_changed)
	
	bus_index = AudioServer.get_bus_index(bus_name)
	
	value = SettingsManager.get_setting(setting)
	
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	
	focus_entered.connect(_play_sound)
	
	update_label()

func _play_sound():
	if visible == false:
		return
	SoundManager.play_sound(sound, 0.0, 0.0)

func _on_value_changed(_new_value):
	volume = value
	update_label()

func _on_setting_changed(path, _value, setter):
	if setter == self: return
	if path == setting:
		value = _value

func update_label():
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	value_label.text = String.num(round(volume * 100))
