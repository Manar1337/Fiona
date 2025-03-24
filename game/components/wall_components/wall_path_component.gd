class_name WallPathComponent
extends WallComponent

var difficulty = 1
var path_range = 25

func _ready():
	type = "path"

func change_left_wall(wall:Wall) -> Wall:
	var upper_rndpoint = get_wall_range(wall.get_polygon().top_section.top_edge.right_coord.x)
	var lower_rndpoint = get_wall_range(wall.get_polygon().top_section.bottom_edge.right_coord.x)
	new_left_wall = wall
	wall.get_polygon().top_section.top_edge.right_coord.x = upper_rndpoint
	wall.get_polygon().top_section.bottom_edge.right_coord.x = lower_rndpoint
	wall.get_polygon().mid_section.top_edge.right_coord.x = lower_rndpoint
	return wall

func change_right_wall(wall:Wall) -> Wall:
	new_right_wall = wall
	wall.get_polygon().top_section.top_edge.right_coord.x = -320 + path_width + new_left_wall.get_polygon().top_section.top_edge.right_coord.x 
	wall.get_polygon().top_section.bottom_edge.right_coord.x = -320 + path_width + new_left_wall.get_polygon().top_section.bottom_edge.right_coord.x
	wall.get_polygon().mid_section.top_edge.right_coord.x = -320 + path_width + new_left_wall.get_polygon().mid_section.top_edge.right_coord.x
	return wall

func get_wall_range(x_coord: float) -> float:
	return clamp(rng.randf_range(x_coord - path_range, x_coord + path_range), 0, 320-path_width)

func set_data(data):
	path_width = data.path_width

func get_path_width():
	return rng.randi_range(min_width, max_width)

func get_parameters():
	return {
		'path_width': get_path_width()
	}
