class_name WallStraightComponent
extends WallComponent

var difficulty = 1
var path_width = 100


func _ready():
	type = "straight"

func get_left_wall(old_wall: Wall, new_wall: Wall):
	var new_shape = new_wall.get_shape()
	var old_shape = old_wall.get_shape()

	for i in range(old_wall.get_sections(), 0, -1):
		new_shape[old_wall.left_indices[i]].x = old_shape[old_wall.left_indices[i - 1]].x

	new_shape[old_wall.left_indices[0]].x = new_shape[old_wall.left_indices[1]].x
	new_wall.set_shape(new_shape)
	left_wall = new_wall
	left_wall.set_color(Color(0.0, 1.0, 0.0))

	return new_wall

func get_right_wall(old_wall: Wall, new_wall: Wall):
	var new_shape = new_wall.get_shape()

	for i in range(right_indices.size()):
		new_shape[right_indices[i]].x = -320 + path_width + left_wall.get_shape()[old_wall.left_indices[i]].x
	new_wall.set_shape(new_shape)
	new_wall.set_color(Color(0.0, 1.0, 0.0))
	return new_wall

func set_data(data):
	path_width = data

func get_parameters():
	return {
		'path_width': path_width
	}
