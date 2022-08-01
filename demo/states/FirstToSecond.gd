extends State


func enter(msg := {}) -> void:
	var pos := 1 if possible_states.find(msg.previous_state) == 0 else 0
	state_machine.transition_to(possible_states[pos])


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func exit() -> void:
	pass
