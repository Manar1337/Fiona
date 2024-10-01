class_name WallPathComponent
extends WallComponent

var type = "path"
var dificulity = 1
var path_width = 100

var left_indices:Array = []
var right_indices:Array = []

func get_left_wall(old_left_wall: Wall, new_left_wall:Wall):
	var x_range = Vector2(32 * dificulity, 132 * dificulity)
	left_wall = new_left_wall
	var new_left_shape = new_left_wall.get_shape()
	new_left_shape[left_indices[2]].x = old_left_wall.get_shape()[left_indices[1]].x
	new_left_shape[left_indices[1]].x = old_left_wall.get_shape()[left_indices[0]].x
	new_left_shape[left_indices[0]].x = randf_range(x_range.x, x_range.y)

	new_left_wall.set_shape(new_left_shape)
	left_wall = new_left_wall
	return new_left_wall

func get_right_wall(_old_right_wall:Wall, new_right_wall:Wall):
	var new_right_shape = new_right_wall.get_shape()

	for i in range(right_indices.size()):
		new_right_shape[right_indices[i]].x = -320 + path_width + left_wall.get_shape()[left_indices[i]].x

	new_right_wall.set_shape(new_right_shape)
	right_wall = new_right_wall
	return new_right_wall

func set_data(data):
	path_width = data
