class_name WallComponentController
extends Node

@export var difficulty: int = 1

var types = {} # Map type names to instances
var wall_sequence = [] # Queue of wall types and counts
var current_wall_info = {'type': "", 'count': 0}
var current_type: WallComponent = null
var wall_data = null

func _ready():
	for child in get_children():
		types[child.type] = child

func add_wall_type(wall_type: String, count: int):
	if not types.has(wall_type):
		push_error("Error: Wall type '" + wall_type + "' was not set.")
		return
	wall_sequence.append({'type': wall_type, 'count': count})

func get_next_walls(old_left_wall: Wall, new_left_wall: Wall, old_right_wall: Wall, new_right_wall: Wall):
	if is_empty():
		push_error("No more walls in sequence.")
		return null

	if current_wall_info['count'] <= 0:
		var _previous_type = current_type
		current_wall_info = wall_sequence.pop_front()
		current_type = types[current_wall_info['type']]
		current_type.left_indices = old_left_wall.left_indices
		current_type.right_indices = old_right_wall.right_indices

		# Handle transitions and generate bridge walls if needed
		#if previous_type != null and previous_type != current_type:
			#print("Need bridge")
		#	var bridge_walls = generate_bridge_walls2()
		#	current_wall_info['count'] += 1 # Adjust count so it doesn't decrease for the bridge
		#	return bridge_walls

	current_wall_info['count'] -= 1

	current_type.set_data(wall_data)
	var left_wall = current_type.get_left_wall(old_left_wall, new_left_wall)
	var right_wall = current_type.get_right_wall(old_right_wall, new_right_wall)
	return {'left': left_wall, 'right': right_wall}

func generate_bridge_walls2():
	pass

func generate_bridge_walls(old_left_wall: Wall, new_left_wall: Wall, old_right_wall: Wall, new_right_wall: Wall, _previous_type: WallComponent, _current_type: WallComponent):
	print("Generate bridge")
	var left_bridge_wall = new_left_wall.duplicate()
	var right_bridge_wall = new_right_wall.duplicate()

	left_bridge_wall.initialize_nodes()
	right_bridge_wall.initialize_nodes()

	var old_left_shape = old_left_wall.get_shape()
	var new_left_shape = new_left_wall.get_shape()

	var bridge_left_shape = []

	for i in range(old_left_shape.size()):
		bridge_left_shape.append((old_left_shape[i] + new_left_shape[i]) / 2)

	left_bridge_wall.set_shape(bridge_left_shape)

	var old_right_shape = old_right_wall.get_shape()
	var new_right_shape = new_right_wall.get_shape()

	var bridge_right_shape = []

	for i in range(old_right_shape.size()):
		bridge_right_shape.append((old_right_shape[i] + new_right_shape[i]) / 2)

	right_bridge_wall.set_shape(bridge_right_shape)

	return {'left': left_bridge_wall, 'right': right_bridge_wall}

func is_empty():
	return current_wall_info == null or (current_wall_info['count'] <= 0 and wall_sequence.size() == 0)

func set_data(data):
	wall_data = data
