extends Area2D

@export_category("Lowpass Trigger")
@export var enable : bool = true
@export_group("On Enter")
@export var cutoff_hz : float = 1000
@export var start_hz : float = 8000
@export var tween : bool = false
@export var easing = Tween.EASE_IN_OUT
@export var transition = Tween.TRANS_LINEAR
@export var duration = 0.5
@export_group("On Exit")
@export var exit_enable : bool = false
@export var exit_cutoff_hz : float = 8000
@export var exit_start_hz : float = 1000
@export var exit_tween : bool = false
@export var exit_easing = Tween.EASE_IN_OUT
@export var exit_transition = Tween.TRANS_LINEAR
@export var exit_duration = 0.5

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exit)

func _on_body_entered(_body):
	if tween == true:
		SoundManager.tween_lowpass(enable, cutoff_hz, start_hz, easing, transition, duration)
		return
	SoundManager.set_lowpass(enable, cutoff_hz)

func _on_body_exit(_body):
	if exit_tween == true:
		SoundManager.tween_lowpass(exit_enable, exit_cutoff_hz, exit_start_hz, exit_easing, exit_transition, exit_duration)
		return
	SoundManager.set_lowpass(exit_enable, exit_cutoff_hz)
