extends Node2D

@onready var viewport = $SubViewport

func add_child_override(child):
	viewport.add_child(child)
