extends Control

export(NodePath) onready var current_state = get_node(current_state) as Label
export(NodePath) onready var state_history = get_node(state_history) as Label
export(NodePath) onready var state_machine = get_node(state_machine) as StateMachine


func _ready() -> void:
	current_state.text = state_machine.state.name
	state_history.text = state_machine.history_data.join("\n")


func _on_StateMachine_transitioned(state_name) -> void:
	current_state.text = state_name
	state_history.text = state_machine.history_data.join("\n")
