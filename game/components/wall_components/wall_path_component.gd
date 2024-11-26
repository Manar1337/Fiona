class_name WallPathComponent
extends WallComponent

var difficulty = 1
var path_width = 100

var rng: RandomNumberGenerator

func _ready():
	type = "path"
	rng = RandomNumberGenerator.new()
	rng.randomize()

func get_left_wall(old_wall: Wall, new_wall: Wall):
	var x_range = Vector2(32 * difficulty, 132 * difficulty)
	var new_shape = new_wall.get_shape()
	var old_shape = old_wall.get_shape()

	for i in range(old_wall.get_sections(), 0, -1):
		new_shape[old_wall.left_indices[i]].x = old_shape[old_wall.left_indices[i - 1]].x

	new_shape[old_wall.left_indices[0]].x = rng.randf_range(x_range.x, x_range.y)
	new_wall.set_shape(new_shape)
	left_wall = new_wall
	left_wall.set_color(Color(1.0, 0.0, 0.0))
	return new_wall


func get_right_wall(_old_right_wall: Wall, new_right_wall: Wall):
	var new_right_shape = new_right_wall.get_shape()
	print(path_width)
	for i in range(right_indices.size()):
		new_right_shape[right_indices[i]].x = -320 + path_width + left_wall.get_shape()[_old_right_wall.left_indices[i]].x
	new_right_wall.set_shape(new_right_shape)
	new_right_wall.set_color(Color(1.0, 0.0, 0.0))
	return new_right_wall

func set_data(data):
	path_width = data

func get_parameters():
	return {
		'path_width': path_width
	}
