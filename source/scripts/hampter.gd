extends Node3D

@export var label : Label
@export var music_player : AudioStreamPlayer

var speed = 0.01

func _ready():
	label.text = String.num(speed) + " Speed"
	SoundManager.set_lowpass(false, 2000)

func _process(delta):
	rotate_x(speed*delta)
	rotate_y(speed*delta*0.75)
	rotate_z(speed*delta*0.5)
	if Input.is_anything_pressed():
		speed += 0.01
		music_player.pitch_scale = 1.0 + speed * 0.01
		label.text = String.num(speed, 2) + " Speed"
