extends Node

var current_checkpoint = Vector2(0, 0)

func move_to_checkpoint(node):
	node.global_position = current_checkpoint
