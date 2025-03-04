extends Node2D

@export var target : Node2D

var current_child_id = 0
var children = 0
var debug_mode = false

func _ready():
	children = get_child_count()
	connect("child_entered_tree", _on_child_entered_tree)
	SettingsManager.setting_changed.connect(_on_setting_changed)
	debug_mode = SettingsManager.get_setting("extras/developer_mode")

func _process(_delta):
	if debug_mode != true:
		return
	if Input.is_action_just_pressed("debug_next_room"):
		current_child_id += 1
		update_child()
	if Input.is_action_just_pressed("debug_last_room"):
		current_child_id -= 1
		update_child()
	if Input.is_action_just_pressed("debug_reset_room"):
		update_child()

func _on_child_entered_tree():
	children = get_child_count()

func _on_setting_changed(path, value, _setter):
	if path != "extras/developer_mode":
		return
	debug_mode = value

func update_child():
	if current_child_id < 0:
		current_child_id = children - 1
	elif current_child_id > children-1:
		current_child_id = 0
	if target == null: return
	target.global_position = get_child(current_child_id).global_position
