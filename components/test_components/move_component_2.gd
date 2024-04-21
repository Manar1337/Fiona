class_name MoveComponent2
extends Node

var modes = []
var mode = ""
var movement_vector = Vector2.ZERO

func _ready():
	for child in get_children():
		modes.append(child.mode)

func _process(delta):
	movement_vector = Vector2.ZERO
	for child in get_children():
		if child.mode != mode: continue
		movement_vector += child.calculate_movement(delta)
		break
	owner.position += movement_vector * delta

func set_mode(new_mode):
		assert(modes.has(new_mode), "Error: Movement mode '" + new_mode + "' was not set.")
		mode = new_mode

func set_speed(new_speed):
	for child in get_children():
		if child.mode != mode: continue
		child.set_speed(new_speed)
		break

func set_mode_data(mode_name, data):
	for child in get_children():
		if child.mode != mode_name: continue
		child.set_data(data)
		break

func get_modes():
	return modes
