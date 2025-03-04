extends Area2D

@export var disable_on_enter : bool
@export var target : Node2D
@export var final_position : Vector2
@export var use_final_position_as_offset : bool = true
@export var easing = Tween.EASE_IN_OUT
@export var transition = Tween.TRANS_LINEAR
@export var duration = 0.5
@export var delay = 0.0

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(_body):
	if disable_on_enter:
		set_deferred("monitoring", false)
	await get_tree().create_timer(delay).timeout
	var tween = get_tree().create_tween()
	tween.set_ease(easing)
	tween.set_trans(transition)
	if use_final_position_as_offset == true:
		tween.tween_property(target, "global_position", final_position + target.global_position, duration)
	else:
		tween.tween_property(target, "global_position", final_position, duration)
