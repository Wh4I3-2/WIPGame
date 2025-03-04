extends PointLight2D

@export_category("Pulsating Light")
@export var _scale : float = 0
@export var offset_scale : float = 1

@export_group("Tween")
@export var first_duration : float = 1
@export var first_easing = Tween.EASE_IN_OUT
@export var first_transition = Tween.TRANS_LINEAR
@export var first_hold : float = 1
@export var second_duration : float = 1
@export var second_easing = Tween.EASE_IN_OUT
@export var second_transition = Tween.TRANS_LINEAR
@export var second_hold : float = 2

var is_first = false

func _ready():
	texture_scale = offset_scale
	_tween()

func _tween():
	var tree = get_tree()
	if tree == null:
		return
	if not is_inside_tree():
		return
	var tween = null
	is_first = !is_first
	if is_first == true:
		await tree.create_timer(second_hold).timeout
		tween = tree.create_tween()
		tween.set_ease(first_easing)
		tween.set_trans(first_transition)
		tween.tween_property(self, "texture_scale", _scale + offset_scale, first_duration)
	else:
		await tree.create_timer(first_hold).timeout
		tween = tree.create_tween()
		tween.set_ease(second_easing)
		tween.set_trans(second_transition)
		tween.tween_property(self, "texture_scale", offset_scale, second_duration)
	if tween != null:
		tween.tween_callback(_tween)
