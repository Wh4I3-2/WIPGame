class_name RectangleGrabState
extends State

@export var state: State

func process(state_owner: Node, delta: float) -> State:
	if not Input.is_action_pressed("grab") or !state_owner.can_grab():
		return state
	return null
