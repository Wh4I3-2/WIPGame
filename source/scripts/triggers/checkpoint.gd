extends Area2D

@export var checkpoint_offset : Vector2
@export var checkpoint : Node2D
@export var disable_on_enter : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", _on_body_entered)
	monitoring = true

func _on_body_entered(_body):
	CheckpointManager.current_checkpoint = global_position + checkpoint_offset
	if checkpoint != null:
		CheckpointManager.current_checkpoint += checkpoint.position
	if disable_on_enter == true:
		set_deferred("monitoring", false)
