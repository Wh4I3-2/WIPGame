extends ButtonPlus

@export_category("Scene Change Button")
@export var scene : PackedScene
@export var ui : bool = false
@export var ui_to_disable : Control
@export var transition_on := SceneManager.Transition.NONE
@export var transition_on_length : float = 0.0
@export var transition_off := SceneManager.Transition.NONE
@export var transition_off_length : float = 0.0

@onready var default_scene = load("res://content/scenes/menu.tscn")

func on_button_up():
	GameManager.main_menu = true
	GameManager.paused = false
	disabled = true
	if scene != null:
		SceneManager.change_scene(scene, !ui, transition_on, transition_on_length, transition_off, transition_off_length)
	else:
		SceneManager.change_scene(default_scene, !ui, transition_on, transition_on_length, transition_off, transition_off_length)
	await SceneManager.transition_scene_changed
	if ui_to_disable != null:
		ui_to_disable.visible = false
	disabled = false
