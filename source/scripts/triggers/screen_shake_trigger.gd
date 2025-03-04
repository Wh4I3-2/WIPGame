extends Area2D

@export var disable_on_enter : bool = true
@export var strength : float = 1.0
@export var tilt : float = 45.0
@export var length : float = 0.0
@export var delay : float = 0.0
@export var set_shake : bool = false

var timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", _on_body_entered)
	monitoring = true
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)

func _process(_delta):
	var camera = CameraManager.current as Camera2DPlus
	if not timer.is_stopped():
		if set_shake:
			camera.set_shake(strength)
			camera.tilt_angle(tilt)
		else:
			camera.add_shake(strength)
			camera.tilt_angle(tilt)

func _on_body_entered(_body):
	if disable_on_enter == true:
		set_deferred("monitoring", false)
	await get_tree().create_timer(delay).timeout
	timer.start(length)
	CameraManager.current.add_shake(strength)
	CameraManager.current.tilt_angle(tilt)
