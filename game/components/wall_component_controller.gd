class_name WallComponentController
extends Node

@export var dificulity: int = 1

var types = []
var type:WallComponent = null

var left_indices = null
var right_indices = null

@onready var wall_path_component: WallPathComponent = $WallPathComponent

func _ready():
	for child in get_children():
		types.append(child.type)
	if types != []:
		set_type(types[0])

func set_type(new_type):
	assert(types.has(new_type), "Error: Wall type '" + new_type + "' was not set.")
	for child in get_children():
		if child.type != new_type: continue
		type = child
		break

func get_walls(old_left_wall: Wall, new_left_wall:Wall, old_right_wall:Wall, new_right_wall:Wall):
	assert(type != null, "Error: No type was set")

	type.left_indices = [1, 2, 3]
	type.right_indices = [0, 5, 4]
	var left_wall =  type.get_left_wall(old_left_wall, new_left_wall)
	var right_wall =  type.get_right_wall(old_right_wall, new_right_wall)
	return {"left":left_wall, "right":right_wall}

func set_type_data(data):
	type.set_data(data)

func get_wall_type():
	return type

func get_wall_types():
	return types
