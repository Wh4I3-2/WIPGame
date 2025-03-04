extends Node

signal player_changed
signal room_id_changed

var player = null : set = _set_player, get = _get_player
var room_id : set = _set_room_id, get = _get_room_id
var paused : set = _set_paused, get = _get_paused
var main_menu : bool = false
var transitioning_room = false

var death_count = 0
var bits = 0

func _ready():
	SignalBus.player_died.connect(_on_player_died)
	
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if WindowManager.focused == false:
		get_tree().paused = true
		return
	if paused == true:
		get_tree().paused = true
	else:
		get_tree().paused = false

func _on_player_died(_player):
	death_count += 1

func _set_player(node):
	player = node
	player_changed.emit()

func _get_player():
	return player
	
func _set_room_id(id):
	room_id = id
	room_id_changed.emit()

func _get_room_id():
	return room_id

func _set_paused(value):
	paused = value

func _get_paused():
	return paused
