tool
extends Control

onready var state_name = $StateName
onready var create_state = $CreateState
onready var is_initial_state = $InitialState
onready var is_transition_state = $TransitionState
onready var available_states = $AvailableStates

var new_state : State
var machine : StateMachine
var tool_button : ToolButton
var script_editor : ScriptCreateDialog
var interface_editor : EditorInterface
var selected_states : PoolStringArray


func _ready() -> void:
	create_state.disabled = true
	available_states.add_color_override("font_color_selected", Color.aquamarine)


func _on_Button_pressed() -> void:
	if is_instance_valid(machine):
		new_state = State.new()
		new_state.name = state_name.text.strip_edges()
		
		script_editor.config("State", "res://" + new_state.name, false)
		script_editor.popup_centered()
	else:
		print_debug("No State Machine selected")


func attach_script(script: Script) -> void:
	new_state.set_script(script)
	machine.add_child(new_state)
	new_state.owner = machine.owner if is_instance_valid(machine.owner) else machine
	new_state.possible_states = selected_states
	clear_selected()
	
	if is_initial_state.pressed:
		machine.initial_state = machine.get_path_to(new_state)
		interface_editor.get_inspector().refresh()
	
	if interface_editor.save_scene() != OK:
		print_debug("Could not save current scene")


func clear_selected() -> void:
	available_states.unselect_all()
	for i in available_states.get_item_count():
		available_states.set_item_custom_fg_color(i, Color.white)
		available_states.set_item_metadata(i, false)
	selected_states = []


func _on_StateName_text_changed(new_text: String) -> void:
	create_state.disabled = new_text.empty()


func _on_visibility_changed(value: bool) -> void:
	tool_button.visible = value
	if tool_button.visible:
		refresh()


func _on_machine_selected(object: StateMachine) -> void:
	machine = object


func refresh() -> void:
	if is_instance_valid(machine):
		selected_states = []
		available_states.clear()
		machine.find_states()
		var index : int = 0
		for state in machine.available_states:
			available_states.add_item(state)
			available_states.set_item_metadata(index, false)
			index += 1


func _on_AvailableStates_item_selected(index: int) -> void:
	var selected : bool = available_states.get_item_metadata(index)
	
	if not selected:
		if is_transition_state.pressed and selected_states.size() == 2:
			return
		
		available_states.set_item_custom_fg_color(index, Color.aquamarine)
		selected_states.append(available_states.get_item_text(index))
		available_states.set_item_metadata(index, true)
	else:
		available_states.set_item_custom_fg_color(index, Color.white)
		available_states.set_item_metadata(index, false)
		var pos : int = selected_states.find(available_states.get_item_text(index))
		selected_states.remove(pos)


func _on_TransitionState_toggled(button_pressed: bool) -> void:
	pass
