class_name Room
extends Node2D

@export var room_id: String
@export var override_room_id: bool = true

func _ready() -> void:
	if override_room_id:
		for child in get_children():
			if not "room_id" in child: continue
			child.room_id = room_id
