class_name RectangleState
extends State

@export var grab_state: State

func process(state_owner: Node, delta: float) -> State:
	if Input.is_action_pressed("grab") and state_owner.can_grab():
		return grab_state
	return null

func physics_process(state_owner: Node, delta: float) -> State:
	var hdir: float = Input.get_axis("move_left", "move_right")
	state_owner.velocity.x = move_toward(state_owner.velocity.x, hdir * state_owner.speed, delta * state_owner.acceleration)
	if !state_owner.player.is_on_floor():
		state_owner.velocity.y = move_toward(state_owner.velocity.y, state_owner.gravity * -state_owner.player.up_direction.y, state_owner.gravity_accel)
	else:
		state_owner.velocity.y = 0
	return null

func selected(state_owner: Node) -> void:
	state_owner.player.up_direction = Vector2(0, -1)
