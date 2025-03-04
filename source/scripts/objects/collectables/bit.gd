extends Collectable

@export var bits : int = 1
@export var hover_distance : float = 2
@export var hover_duration : float = 1

var frame = 0
var direction = Vector2.UP

func on_ready():
	var offset = randf_range(0.0, 2.0)
	await get_tree().create_timer(offset).timeout
	tween_sprite()

func on_collected():
	GameManager.bits += bits

func tween_sprite():
	if get_tree() == null:
		return
	direction = -direction
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "position", direction * hover_distance, hover_duration)
	var tween_2 = get_tree().create_tween()
	tween_2.set_ease(Tween.EASE_OUT)
	tween_2.set_trans(Tween.TRANS_QUAD)
	tween_2.tween_property(light, "position", direction * hover_distance, hover_duration)
	tween.tween_callback(tween_sprite)
