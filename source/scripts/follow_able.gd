class_name FollowAble
extends Node2D

signal new_first_follower(follower)

@export var follow_group = ""
@export var speed = 4
@export var min_distance = 16

var followers = []
var last_first_follower = null

func _process(delta):
	for follower_id in range(len(followers)):
		var follower = followers[follower_id]
		if follower_id > 0:
			var distance = followers[follower_id-1].global_position.distance_to(follower.global_position)
			if distance > min_distance:
				follower.global_position = follower.global_position.lerp(followers[follower_id-1].global_position, delta * speed)
		else:
			var distance = global_position.distance_to(follower.global_position)
			if distance > min_distance:
				follower.global_position = follower.global_position.lerp(global_position, delta * speed)
			else:
				follower.global_position.y = lerp(follower.global_position.y, global_position.y, delta * speed)
				follower.global_position = follower.global_position.round()
	if len(followers) > 0:
		var first = followers[0]
		if last_first_follower != first:
			new_first_follower.emit(first)
			last_first_follower = first
