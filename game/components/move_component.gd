class_name MoveComponent
extends Node

@export var active : bool = true

var modes = []
var mode = null
var movement_vector = Vector2.ZERO
var is_moving = true

func _ready():
	if not active: return
	for child in get_children():
		modes.append(child.mode)
	if modes != []:
		set_mode(modes[0])

func _process(delta):
	if not active: return
	if not is_moving: return
	movement_vector = Vector2.ZERO
	movement_vector += mode.calculate_movement(delta)

	owner.position += movement_vector * delta


func set_mode(new_mode):
	assert(modes.has(new_mode), "Error: Movement mode '" + new_mode + "' was not set.")
	for child in get_children():
		if child.mode != new_mode: continue
		mode = child
		break

func set_speed(new_speed):
	mode.set_speed(new_speed)

func set_mode_data(data):
	mode.set_data(data)

func get_modes():
	return modes

func stop():
	is_moving = false

func start():
	is_moving = true
