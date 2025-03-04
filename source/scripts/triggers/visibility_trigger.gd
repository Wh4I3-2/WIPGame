extends Area2D

@export var disable_on_enter : bool
@export var _visible : bool
@export var target : Node2D
@export var delay = 0.0

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(_body):
	if disable_on_enter:
		set_deferred("monitoring", false)
	await get_tree().create_timer(delay).timeout
	target.visible = _visible
