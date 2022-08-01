tool
extends Node
class_name StateMachine, "res://addons/state_machine/res/state_machine_icon.svg"


signal transitioned(state_name)

export(NodePath) var initial_state
export(bool) var history

var state: State
var history_data: PoolStringArray
var available_states: PoolStringArray


func _enter_tree() -> void:
	if not Engine.editor_hint:
		state = get_node(initial_state)


func _ready() -> void:
	if not Engine.editor_hint:
		if is_instance_valid(owner):
			yield(owner, "ready")
		
		for child in get_children():
			if child is State:
				child.state_machine = self as StateMachine
				if not available_states.has(child.name):
					available_states.append(child.name)
		
		if not is_instance_valid(state):
			print_debug("Please add a initial state to the machine before running.")
		
		state.enter()


func _unhandled_input(event: InputEvent) -> void:
	if not Engine.editor_hint:
		state.handle_input(event)


func _process(delta: float) -> void:
	if not Engine.editor_hint:
		state.update(delta)


func _physics_process(delta: float) -> void:
	if not Engine.editor_hint:
		state.physics_update(delta)


func find_states() -> void:
	for child in get_children():
		if child is State:
			if not available_states.has(child.name):
				available_states.append(child.name)


func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return
	
	if not state.possible_states.has(target_state_name):
		print_debug("Not possible to go from state %s to %s" % [state.name, target_state_name])
		return
	
	if history:
		history_data.append(state.name)
	
	msg["previous_state"] = state.name
	state.exit()
	
	state = get_node(target_state_name)
	state.enter(msg)
	
	emit_signal("transitioned", state.name)


func _get_configuration_warning() -> String:
	var msg := "Add a initial state to the machine before running"
	return msg if initial_state.is_empty() else ""
