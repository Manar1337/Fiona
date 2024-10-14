class_name WallPathComponent
extends WallComponent

var difficulty = 1
var path_width = 100

var rng: RandomNumberGenerator

func _ready():
	type = "path"
	rng = RandomNumberGenerator.new()
	rng.randomize()

func get_left_wall(old_left_wall: Wall, new_left_wall: Wall):
	var x_range = Vector2(32 * difficulty, 132 * difficulty)
	left_wall = new_left_wall
	var new_left_shape = new_left_wall.get_shape()
	var old_left_shape = old_left_wall.get_shape()

	for i in range(old_left_wall.get_sections(), 0, -1):
		new_left_shape[old_left_wall.left_indices[i]].x = old_left_shape[old_left_wall.left_indices[i - 1]].x

	new_left_shape[old_left_wall.left_indices[0]].x = rng.randf_range(x_range.x, x_range.y)
	new_left_wall.set_shape(new_left_shape)
	return new_left_wall


func get_right_wall(_old_right_wall: Wall, new_right_wall: Wall):
	var new_right_shape = new_right_wall.get_shape()

	for i in range(right_indices.size()):
		new_right_shape[right_indices[i]].x = -320 + path_width + left_wall.get_shape()[_old_right_wall.left_indices[i]].x
	new_right_wall.set_shape(new_right_shape)

	return new_right_wall

func set_data(data):
	path_width = data

func get_parameters():
	return {
		'path_width': path_width
	}
