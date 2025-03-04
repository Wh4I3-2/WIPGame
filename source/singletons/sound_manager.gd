extends Node2D

func play_sound(sound : AudioStream, db = 0.0, pitch_offset = 0.0):
	if sound == null:
		return
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = &"SFX"
	audio_player.stream = sound
	audio_player.pitch_scale = _random_pitch_variation() + pitch_offset
	audio_player.volume_db = db
	if SceneManager.current_scene != null:
		SceneManager.current_scene.add_child(audio_player)
		audio_player.play()
	await audio_player.finished
	audio_player.queue_free()

func play_sound_2d(sound : AudioStream, _position : Vector2):
	if sound == null:
		return
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.bus = &"SFX"
	audio_player.stream = sound
	audio_player.global_position = _position
	audio_player.pitch_scale = _random_pitch_variation()
	SceneManager.current_scene.add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()

func _random_pitch_variation(_min = 0.9, _max = 1.05):
	return randf_range(_min, _max)

func set_lowpass(enabled, hz = 2000.0):
	var music_bus = AudioServer.get_bus_index("Music")
	for effect in range(AudioServer.get_bus_effect_count(music_bus)):
		if AudioServer.get_bus_effect(music_bus, effect) is AudioEffectLowPassFilter:
			AudioServer.set_bus_effect_enabled(music_bus, 0, enabled)
			AudioServer.get_bus_effect(music_bus, effect).cutoff_hz = hz
	var sfx_bus = AudioServer.get_bus_index("SFX")
	for effect in range(AudioServer.get_bus_effect_count(sfx_bus)):
		if AudioServer.get_bus_effect(sfx_bus, effect) is AudioEffectLowPassFilter:
			AudioServer.set_bus_effect_enabled(sfx_bus, 0, enabled)
			AudioServer.get_bus_effect(sfx_bus, effect).cutoff_hz = hz

func tween_lowpass(enabled, hz = 1500.0, start_hz = 8000.0, easing = Tween.EASE_IN_OUT, transition = Tween.TRANS_LINEAR, duration = 1.0):
	var music_bus = AudioServer.get_bus_index("Music")
	for effect in range(AudioServer.get_bus_effect_count(music_bus)):
		if AudioServer.get_bus_effect(music_bus, effect) is AudioEffectLowPassFilter:
			AudioServer.set_bus_effect_enabled(music_bus, 0, enabled)
			AudioServer.get_bus_effect(music_bus, effect).cutoff_hz = start_hz
			var tween = get_tree().create_tween()
			tween.set_ease(easing)
			tween.set_trans(transition)
			tween.tween_property(AudioServer.get_bus_effect(music_bus, effect), "cutoff_hz", hz, duration)
	var sfx_bus = AudioServer.get_bus_index("SFX")
	for effect in range(AudioServer.get_bus_effect_count(sfx_bus)):
		if AudioServer.get_bus_effect(sfx_bus, effect) is AudioEffectLowPassFilter:
			AudioServer.set_bus_effect_enabled(sfx_bus, 0, enabled)
			AudioServer.get_bus_effect(sfx_bus, effect).cutoff_hz = start_hz
			var tween = get_tree().create_tween()
			tween.set_ease(easing)
			tween.set_trans(transition)
			tween.tween_property(AudioServer.get_bus_effect(sfx_bus, effect), "cutoff_hz", hz, duration)
