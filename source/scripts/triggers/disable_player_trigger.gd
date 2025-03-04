extends Area2D

@export var disable_on_enter : bool = true
@export var length : float = 0.0
@export var delay : float = 0.0

var timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", _on_body_entered)
	monitoring = true
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)

func _on_body_entered(_body):
	if disable_on_enter == true:
		set_deferred("monitoring", false)
	await get_tree().create_timer(delay).timeout
	GameManager.player.disable_movement = true
	await get_tree().create_timer(length).timeout
	GameManager.player.disable_movement = false
