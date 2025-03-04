extends Node2D

@export var target : Node2D
@export var speed : float = 1
@export var offset : Vector2

func _process(delta):
	if target == null:
		return
	global_position = global_position.lerp(target.global_position + offset, delta * speed)
