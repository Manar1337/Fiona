class_name WallStraightComponent
extends WallComponent

var path_x_coord = rng.randi_range(0,170)
var difficulty = 1

func _ready():
	type = "straight"

func change_left_wall(wall:Wall) -> Wall:
	new_left_wall = wall
	wall.get_polygon().top_section.top_edge.right_coord.x       = path_x_coord
	wall.get_polygon().top_section.bottom_edge.right_coord.x    = path_x_coord

	wall.get_polygon().mid_section.top_edge.right_coord.x       = path_x_coord
	wall.get_polygon().mid_section.bottom_edge.right_coord.x    = path_x_coord

	wall.get_polygon().bottom_section.top_edge.right_coord.x    = path_x_coord
	wall.get_polygon().bottom_section.bottom_edge.right_coord.x = path_x_coord
	return wall

func change_right_wall(wall:Wall) -> Wall:
	new_right_wall = wall
	wall.get_polygon().top_section.top_edge.right_coord.x       = -320 + path_width + new_left_wall.get_polygon().top_section.top_edge.right_coord.x 
	wall.get_polygon().top_section.bottom_edge.right_coord.x    = -320 + path_width + new_left_wall.get_polygon().top_section.bottom_edge.right_coord.x

	wall.get_polygon().mid_section.top_edge.right_coord.x       = -320 + path_width + new_left_wall.get_polygon().mid_section.top_edge.right_coord.x
	wall.get_polygon().mid_section.bottom_edge.right_coord.x    = -320 + path_width + new_left_wall.get_polygon().mid_section.bottom_edge.right_coord.x

	wall.get_polygon().bottom_section.top_edge.right_coord.x    = -320 + path_width + new_left_wall.get_polygon().bottom_section.top_edge.right_coord.x
	wall.get_polygon().bottom_section.bottom_edge.right_coord.x = -320 + path_width + new_left_wall.get_polygon().bottom_section.bottom_edge.right_coord.x
	return wall

func set_data(data):
	path_width = data.path_width
	path_x_coord = data.path_x_coord

func get_path_width():
	return rng.randi_range(min_width, max_width)

func get_parameters():
	return {
		'path_x_coord': path_x_coord,
		'path_width': get_path_width()
	}
