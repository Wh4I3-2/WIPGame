extends Node

@export var spinning_object: Node2D
@export var rpm: float = 20

func _process(delta: float) -> void:
	spinning_object.rotate(deg_to_rad(rpm * 360 / 60 * delta))
