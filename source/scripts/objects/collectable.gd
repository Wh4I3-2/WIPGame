class_name Collectable
extends Area2D

@export var follow_group : String = ""
@export var collect_time : float = 0.6
@export var chain_collect_time : float = 0.1
@export var only_collect_on_floor : bool = true
@export var collect_particles : PackedScene
@export_range(0, 1) var collect_shake : float = 0.4
@export var return_duration : float = 1.75
@export var return_easing = Tween.EASE_OUT
@export var return_transition = Tween.TRANS_BACK
@export var pickup_sound : AudioStream
@export var collect_start_sound : AudioStream
@export var collect_finish_sound : AudioStream

@onready var timer = Timer.new()

var leader : FollowAble = null 
var last_pos = Vector2.ZERO
var first_to_get_collected = false
var collected = false
var initial_position = Vector2.ZERO
var sprite = null
var light = null

var _collect_time = 0.0
var is_chain = false

func _ready():
	_collect_time = collect_time
	if has_node("Sprite2D"):
		sprite = $Sprite2D
	if has_node("PointLight2D"):
		light = $PointLight2D
	initial_position = global_position
	connect("body_entered", _on_body_entered)
	
	timer.one_shot = true
	add_child(timer)
	
	on_ready()

func on_ready():
	pass

func _process(_delta):
	var leader_owner = null
	if leader != null:
		leader_owner = leader.get_parent()
	if leader_owner is CharacterBody2D:
		if leader_owner.is_on_floor() and is_chain == true:
			_collect_time = 0.05
		else:
			for follower in leader.followers:
				follower.set_deferred("is_chain", false)
			_collect_time = collect_time
		if last_pos != global_position or not leader_owner.is_on_floor():
			last_pos = global_position
			timer.start(_collect_time)
	else:
		if last_pos != global_position:
			last_pos = global_position
			timer.start(_collect_time)
	if timer.is_stopped() and first_to_get_collected:
		collect()

func collect():
	if collected == true:
		return
	if GameManager.paused == true:
		return
	if GameManager.transitioning_room == true:
		return
	collected = true
	leader.followers.erase(self)
	if collect_start_sound != null:
		SoundManager.play_sound(collect_start_sound, -2.0, 0.0)
	if sprite != null:
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BACK)
		tween.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.2)
		var rot_tween = get_tree().create_tween()
		rot_tween.set_ease(Tween.EASE_OUT)
		rot_tween.set_trans(Tween.TRANS_BACK)
		rot_tween.tween_property(sprite, "rotation_degrees", 55, 0.2)
		await tween.finished
		var tween2 = get_tree().create_tween()
		tween2.set_ease(Tween.EASE_OUT)
		tween2.set_trans(Tween.TRANS_QUART)
		tween2.tween_property(sprite, "scale", Vector2(0, 0), 0.2)
		var rot_tween2 = get_tree().create_tween()
		rot_tween2.set_ease(Tween.EASE_IN)
		rot_tween2.set_trans(Tween.TRANS_CIRC)
		rot_tween2.tween_property(sprite, "rotation_degrees", -720, 0.2)
		await tween2.finished
	if collect_particles != null:
		SceneManager.spawn_object(collect_particles, global_position)
	if collect_finish_sound != null:
		SoundManager.play_sound(collect_finish_sound, -6.0, 0.0)
	CameraManager.current.set_shake(collect_shake)
	for follower in leader.followers:
		follower.set_deferred("is_chain", true)
	on_collected()
	queue_free()

func on_collected():
	pass

func _on_body_entered(body : Node2D):
	if leader != null:
		return
	for child in body.get_children():
		if child is FollowAble:
			var followable = child as FollowAble
			if followable.follow_group != follow_group:
				continue
			if followable == leader:
				continue
			if pickup_sound != null:
				SoundManager.play_sound(pickup_sound, -5.0, 0.0)
			followable.followers.append(self)
			leader = followable
			followable.connect("new_first_follower", _on_new_first_follower)
			break

func _on_new_first_follower(follower):
	if follower == self:
		first_to_get_collected = true
		if leader.get_parent() is CharacterBody2D:
			if leader.get_parent().is_on_floor():
				_collect_time = chain_collect_time

func reset():
	leader.disconnect("new_first_follower", _on_new_first_follower)
	leader = null
	collected = false
	first_to_get_collected = false
	monitoring = false
	var tween = get_tree().create_tween()
	tween.set_ease(return_easing)
	tween.set_trans(return_transition)
	tween.tween_property(self, "global_position", initial_position, return_duration)
	await tween.finished
	monitoring = true
