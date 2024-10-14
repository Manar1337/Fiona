class_name WallStraightComponent
extends WallComponent

var difficulty = 1
var path_width = 100


func _ready():
	type = "straight"

func get_left_wall(old_left_wall: Wall, new_left_wall: Wall):
	left_wall = new_left_wall
	var new_left_shape = new_left_wall.get_shape()
	var old_left_shape = old_left_wall.get_shape()

	for i in range(old_left_wall.get_sections(), 0, -1):
		new_left_shape[old_left_wall.left_indices[i]].x = old_left_shape[old_left_wall.left_indices[i - 1]].x

	new_left_shape[old_left_wall.left_indices[0]].x = new_left_shape[old_left_wall.left_indices[1]].x
	new_left_wall.set_shape(new_left_shape)
	return new_left_wall

func get_right_wall(_old_right_wall: Wall, new_right_wall: Wall):
	var new_right_shape = new_right_wall.get_shape()

	for i in range(right_indices.size()):
		new_right_shape[right_indices[i]].x = -320 + path_width + left_wall.get_shape()[_old_right_wall.left_indices[i]].x
	new_right_wall.set_shape(new_right_shape)

	return new_right_wall

func set_data(_data):
	pass # No data needed for straight walls

func get_parameters():
	return {} # No additional parameters needed
