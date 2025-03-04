extends Area2D

@export var gravity_scale : float
@export var change_gravity_on_exit : bool = false
@export var gravity_scale_on_exit : float = 1

func _ready():
	connect("body_entered", _on_body_entered)
	if change_gravity_on_exit:
		connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	body.set_deferred("gravity_scale", gravity_scale)

func _on_body_exited(body):
	body.set_deferred("gravity_scale", gravity_scale_on_exit)
