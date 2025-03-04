extends Node3D

@export var rot : Vector3
@export var rand_rot_offset : Vector3

func _ready():
	var offset = Vector3(randf_range(0, rand_rot_offset.x), randf_range(0, rand_rot_offset.y), randf_range(0, rand_rot_offset.z))
	rotation_degrees += offset

func _process(delta):
	rotation_degrees += rot * delta
	rotation_degrees.x -= 720 * int(rotation_degrees.x > 360)
	rotation_degrees.x += 720 * int(rotation_degrees.x < -360)
	rotation_degrees.y -= 720 * int(rotation_degrees.y > 360)
	rotation_degrees.y += 720 * int(rotation_degrees.y < -360)
	rotation_degrees.z -= 720 * int(rotation_degrees.z > 360)
	rotation_degrees.z += 720 * int(rotation_degrees.z < -360)
