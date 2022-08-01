extends Node
class_name State

export(PoolStringArray) var possible_states: PoolStringArray = []

var character: Node
var state_machine: Node


func _ready() -> void:
	if is_instance_valid(owner):
		yield(owner, "ready")
	
	character = owner as Node


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	pass


func exit() -> void:
	pass
