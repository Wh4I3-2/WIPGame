class_name StateMachine
extends Node

@export var state_owner: Node
@export var default_state: State

var state: State

func _ready() -> void:
	state = default_state

func _process(delta: float) -> void:
	var new_state: State = state.process(state_owner, delta)
	handle_new_state(new_state)
	
func _physics_process(delta: float) -> void:
	var new_state: State = state.physics_process(state_owner, delta)
	handle_new_state(new_state)
	
func _input(event: InputEvent) -> void:
	print("a")
	var new_state: State = state.input(state_owner, event)
	handle_new_state(new_state)

func handle_new_state(new_state: State) -> void:
	if new_state == null: return
	state = new_state
	state.selected(state_owner)
