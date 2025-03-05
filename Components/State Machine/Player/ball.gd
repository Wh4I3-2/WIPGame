class_name BallState
extends State

func process(state_owner: Node, _delta: float) -> State:
	if state_owner.player.is_on_floor():
		if Input.is_action_just_pressed("grab"):
			state_owner.flipped = !state_owner.flipped
		if Input.is_action_just_pressed("jump"):
			state_owner.velocity.y = state_owner.jump_strength * state_owner.player.up_direction.y
	return null

func physics_process(state_owner: Node, delta: float) -> State:
	var hdir: float = Input.get_axis("move_left", "move_right")
	state_owner.velocity.x = move_toward(state_owner.velocity.x, hdir * state_owner.speed, delta * state_owner.acceleration)
	if !state_owner.player.is_on_floor():
		state_owner.velocity.y = move_toward(state_owner.velocity.y, state_owner.gravity * -state_owner.player.up_direction.y, state_owner.gravity_accel)
	else:
		state_owner.velocity.y = 0
	return null

func input(state_owner: Node, event: InputEvent) -> State: 
	return null

func selected(_state_owner: Node) -> void:
	pass
