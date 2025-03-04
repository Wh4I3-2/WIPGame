extends Area2D

@export_category("Camera Activator")
@export var room_id : int

@export_subgroup("Limit")
@export var limit_top    : float
@export var limit_left   : float
@export var limit_right  : float
@export var limit_bottom : float
@export var limit_offset : Vector2
@export var set_offset_to_global_position : bool = false

@export_subgroup("Limit Tween")
@export var duration : float
@export var easing := Tween.EASE_IN_OUT
@export var transition := Tween.TRANS_LINEAR

@export_subgroup("Body Entered Tween")
@export var body_entered_enabled : bool
@export var body_entered_wait_for_limit : bool = true
@export var body_entered_duration : float
@export var body_entered_easing := Tween.EASE_IN_OUT
@export var body_entered_transition := Tween.TRANS_LINEAR
@export var body_entered_offset : Vector2

@onready var collision_shape = $CollisionShape2D

var _limit_offset : Vector2
var _body = null

func _ready():
	connect("area_entered", _on_area_entered)
	if set_offset_to_global_position:
		_limit_offset = global_position
	else:
		_limit_offset = limit_offset

func _on_area_entered(area : Area2D):
	if GameManager.room_id == room_id:
		return
	
	GameManager.room_id = room_id
	GameManager.transitioning_room = true
	
	var limit_tween = CameraManager.current.set_limits(round(limit_top+_limit_offset.y), round(limit_left+_limit_offset.x), round(limit_right+_limit_offset.x), round(limit_bottom+_limit_offset.y), duration, easing, transition)
	
	var parent = area.get_parent()
	_body = parent
	
	if body_entered_enabled:
		if _body is Player:
			_body.reset()
		
		_body.process_mode = Node.PROCESS_MODE_DISABLED
		
		if body_entered_wait_for_limit:
			await limit_tween.finished
		
		var tween : Tween = create_tween()
		tween.set_ease(body_entered_easing)
		tween.set_trans(body_entered_transition)
		
		tween.tween_property(_body, "global_position", _body.global_position + body_entered_offset, body_entered_duration)
		
		tween.tween_callback(_on_tween_finished)

func _on_tween_finished():
	_body.process_mode = Node.PROCESS_MODE_INHERIT
	GameManager.transitioning_room = false
