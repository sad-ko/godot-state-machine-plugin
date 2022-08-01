extends State


func enter(_msg := {}) -> void:
	pass


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		state_machine.transition_to("FirstToSecond")
	elif Input.is_action_just_pressed("ui_right"):
		state_machine.transition_to("Third")


func exit() -> void:
	pass
