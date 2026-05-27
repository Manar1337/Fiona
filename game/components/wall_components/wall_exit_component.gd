class_name WallExitComponent
extends WallComponent

var path_x_coord: float = 0.0

func _ready():
	type = "exit"
	nr_of_segments = 3

func change_left_wall(wall: Wall) -> Wall:
	new_left_wall = wall
	wall.get_polygon().top_section.top_edge.right_coord.x = 0.0
	wall.get_polygon().top_section.bottom_edge.right_coord.x = path_x_coord
	wall.get_polygon().mid_section.top_edge.right_coord.x = path_x_coord
	return wall

func change_right_wall(wall: Wall) -> Wall:
	new_right_wall = wall
	var tunnel_right_x = -320.0 + path_width + path_x_coord
	wall.get_polygon().top_section.top_edge.right_coord.x = 0.0
	wall.get_polygon().top_section.bottom_edge.right_coord.x = tunnel_right_x
	wall.get_polygon().mid_section.top_edge.right_coord.x = tunnel_right_x
	return wall

func set_data(data):
	path_width = data.path_width
	path_x_coord = data.path_x_coord

func get_path_width():
	return rng.randi_range(min_width, max_width)

func get_parameters():
	return {
		"path_width": get_path_width()
	}
