extends Control

enum Transition {
	FADE,
	NONE
}

signal transition_started
signal transition_scene_changed
signal transition_finished

var current_scene : Node = null
var _current_packed_scene : PackedScene = null
var root = null
@onready var root_scene = preload("res://content/scenes/root.tscn")

var _transition_canvas : CanvasLayer
var _transition_rect : ColorRect
var _default_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_default_scene = PackedScene.new()
	_default_scene.pack(get_tree().current_scene)
	get_tree().current_scene.queue_free()
	
	var root_instance = root_scene.instantiate()
	root = root_instance
	get_tree().root.add_child.call_deferred(root)
	
	change_scene(_default_scene, false, Transition.NONE, 0.0, Transition.NONE, 0.0)
	
	_transition_canvas = CanvasLayer.new()
	_transition_canvas.layer = 100
	_transition_rect = ColorRect.new()
	_transition_rect.color = Color(Color.BLACK, 0.0)
	_transition_canvas.add_child(_transition_rect)
	_transition_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_transition_canvas)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	_transition_rect.mouse_filter = Control.MOUSE_FILTER_PASS

func change_scene(scene : PackedScene, allow_override : bool = true, transition = Transition.NONE, length = 0.0, transition_2 = null, length_2 = null):
	if transition_2 == null:
		transition_2 = transition
	if length_2 == null:
		length_2 = length
	if scene != null:
		call_deferred("_defferred_change_scene", scene, allow_override, transition, length, transition_2, length_2)

func _defferred_change_scene(scene : PackedScene, allow_override, transition, length, transition_2, length_2):
	_transition(transition, length, transition_2, length_2)
	await transition_scene_changed
	if current_scene != null:
		current_scene.queue_free()
	var instance = scene.instantiate()
	if root.has_method("add_child_override") and allow_override:
		root.add_child_override(instance)
	else:
		root.add_child(instance)
	current_scene = instance
	_current_packed_scene = scene

func reload_current_scene():
	change_scene(_current_packed_scene)

func spawn_object(object, pos):
	if object == null:
		return
	if object is PackedScene:
		var instance = object.instantiate()
		instance.global_position = pos
		current_scene.add_child(instance)

func _transition(transition, length, transition_2, length_2):
	var tween: Tween = get_tree().create_tween()
	transition_started.emit()
	match transition:
		Transition.FADE:
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(_transition_rect, "color", Color(_transition_rect.color, 1.0), length)
	await tween.finished
	transition_scene_changed.emit()
	tween = get_tree().create_tween()
	match transition_2:
		Transition.FADE:
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(_transition_rect, "color", Color(_transition_rect.color, 0.0), length_2)
	await tween.finished
	transition_finished.emit()
	
