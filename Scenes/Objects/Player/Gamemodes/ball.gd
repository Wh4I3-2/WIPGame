class_name BallGameMode
extends GameMode

@export var rpm: float = 30

var flipped: bool = false

func _physics_process(delta: float) -> void:
	player.up_direction = Vector2(0, 1 - int(!flipped) * 2)

func process_body(delta: float) -> void:
	body.rotate(rpm / 360 * 60 * delta * abs(velocity.x) / speed)
	pivot.scale.y = lerpf(pivot.scale.y, (float(flipped) * 2.0 - 1.0) * -1, delta * 10.0)
