extends Area2D

@export var scene : PackedScene = preload("res://content/scenes/menu.tscn")
@export var is_ui : bool
@export var transition_on := SceneManager.Transition.NONE
@export var transition_on_length : float = 0.0
@export var transition_off := SceneManager.Transition.NONE
@export var transition_off_length : float = 0.0

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(_body):
	GameManager.main_menu = true
	GameManager.paused = false
	SceneManager.change_scene(scene, !is_ui, transition_on, transition_on_length, transition_off, transition_off_length)
