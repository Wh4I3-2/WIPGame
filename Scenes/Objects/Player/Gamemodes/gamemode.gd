class_name GameMode
extends Node

@export var collision_shape: Shape2D
@export var collision_offset: Vector2
@export var player: Player

@export var eyes:       Node2D
@export var mouth:      Node2D
@export var hat:        Node2D
@export var body:       Node2D
@export var flip_pivot: Node2D
@export var pivot:      Node2D

@export var speed: float = 200
@export var acceleration: float = 600
@export var gravity: float = 200
@export var gravity_accel: float = 100
@export var jump_strength: float = 200

var velocity: Vector2

func _process(delta: float) -> void:	
	process_face(delta)
	process_body(delta)

var target_sprite_scale_x: float = 1.0
func process_face(delta: float) -> void:
	if velocity.x > 0: target_sprite_scale_x = 1
	if velocity.x < 0: target_sprite_scale_x = -1
	flip_pivot.scale.x = lerpf(flip_pivot.scale.x, target_sprite_scale_x, delta * 10.0)
	mouth.scale.y = lerpf(1.0, 1.02, abs(velocity.y))
	mouth.scale.y = clamp(mouth.scale.y, 1, 10)
	eyes.scale.y = lerpf(1.0, 1.005, abs(velocity.y)/2.0)
	eyes.scale.y = clamp(eyes.scale.y, 1, 3)
	hat.offset.y = lerpf(0.0, -0.02, velocity.y)
	hat.offset.y = clamp(hat.offset.y, -6, 0)

func process_body(delta: float) -> void:
	pass
