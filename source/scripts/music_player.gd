class_name MusicPlayer
extends AudioStreamPlayer

@export var intro : AudioStream
@export var loop : AudioStream
@export var glitch : bool
@export var glitch_chance : float
@export var glitch_setback_range : float
@export var glitch_try_freq : float
@export var glitch_amount_range : int

var pause = false

func _ready():
	stream = loop
	if intro != null:
		stream = intro
	playing = true
	
	connect("finished", _on_finished)
	
	if glitch == true:
		var glitch_timer = get_tree().create_timer(glitch_try_freq)
		glitch_timer.connect("timeout", _on_glitch_timer_timeout)

func _process(_delta):
	if pause == true:
		playing = false
	else:
		if playing == false:
			playing = true

func _on_finished():
	stream = loop
	playing = true

func _on_glitch_timer_timeout():
	if randf_range(0, 1) <= glitch_chance:
		for i in range(randi_range(1, glitch_amount_range)):
			var setback = randf_range(0, glitch_setback_range)
			if SettingsManager.get_setting("audio/disable_music_glitches") == false and pause == false:
				play(get_playback_position() - setback)
			await get_tree().create_timer(setback).timeout
	var glitch_timer = get_tree().create_timer(glitch_try_freq)
	glitch_timer.connect("timeout", _on_glitch_timer_timeout)
