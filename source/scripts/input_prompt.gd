extends Control

enum Devices {
	AUTO,
	KEYBOARD,
	CONTROLLER
}

@export var action : String = "":
	set(value):
		action = value
		update_texture()
	get:
		return action
@export var device : Devices = Devices.AUTO :
	set(value):
		device = value
		update_texture()
	get:
		return device

@onready var sprite : TextureRect = $Sprite2D
@onready var outline : TextureRect = $Outline

func _ready():
	InputHelper.keyboard_input_changed.connect(func(_action_name, _key): update_texture())
	InputHelper.joypad_input_changed.connect(func(_action_name, _button_index): update_texture())
	
	if device == Devices.AUTO:
		InputHelper.device_changed.connect(func(_d, _index): update_texture())
	
	update_texture()
	
	outline.modulate = Color.BLACK

func get_texture_path_for_action(_action : String, _device : String) -> String:
	if _device == InputHelper.DEVICE_KEYBOARD:
		var keyboard_input = InputHelper.get_keyboard_input_for_action(_action)
		return "res://assets/textures/input/keyboard/keyboard_%s" % InputHelper.get_label_for_input(keyboard_input).to_lower()
	else:
		var joypad_input = InputHelper.get_joypad_input_for_action(_action)
		return "res://assets/textures/input/%s/%d" % [_device.to_lower(), joypad_input.button_index.to_lower()]

func update_texture():
	if sprite == null: return
	
	var path = get_texture_path_for_action(action, InputHelper.DEVICE_KEYBOARD)
	if not path.ends_with("keyboard_"):
		sprite.texture = load(path + ".svg")
		outline.texture = load(path + "_outline.svg")
