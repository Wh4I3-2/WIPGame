extends Area2D

@export var enter_audio_player : MusicPlayer
@export var exit_audio_player : MusicPlayer

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exit)

func _on_body_entered(_body):
	enter_audio_player.pause = false
	exit_audio_player.pause = true

func _on_body_exit(_body):
	enter_audio_player.pause = true
	exit_audio_player.pause = false
