class_name MoveComponent
extends Node

var modes = []
var mode_name = ""
var mode = null
var movement_vector = Vector2.ZERO

func _ready():
	for child in get_children():
		modes.append(child.mode)
	if modes != []:
		set_mode(modes[0])

func _process(delta):
	movement_vector = Vector2.ZERO
	movement_vector += mode.calculate_movement(delta)

	owner.position += movement_vector * delta

func set_mode(new_mode):
		assert(modes.has(new_mode), "Error: Movement mode '" + new_mode + "' was not set.")
		mode_name = new_mode
		for child in get_children():
			if child.mode != mode_name: continue
			mode = child
			break

func set_speed(new_speed):
	mode.set_speed(new_speed)

func set_mode_data(data):
	mode.set_data(data)

func get_modes():
	return modes
