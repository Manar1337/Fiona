class_name WallPathComponent
extends WallComponent

var difficulty = 1
var path_range = 25
var current_path_range = 25.0
var forced_path_x_coord = null
var target_path_x_coord = null
var active_data_signature: String = ""

func _ready():
	type = "path"
	current_path_range = float(path_range)

func change_left_wall(wall:Wall) -> Wall:
	var upper_rndpoint = forced_path_x_coord if forced_path_x_coord != null else get_wall_range(wall.get_polygon().top_section.top_edge.right_coord.x)
	var lower_rndpoint = _get_forced_lower_rndpoint() if forced_path_x_coord != null else get_wall_range(wall.get_polygon().top_section.bottom_edge.right_coord.x)
	new_left_wall = wall
	wall.get_polygon().top_section.top_edge.right_coord.x = upper_rndpoint
	wall.get_polygon().top_section.bottom_edge.right_coord.x = lower_rndpoint
	wall.get_polygon().mid_section.top_edge.right_coord.x = lower_rndpoint
	forced_path_x_coord = lower_rndpoint
	return wall

func change_right_wall(wall:Wall) -> Wall:
	new_right_wall = wall
	wall.get_polygon().top_section.top_edge.right_coord.x = -320 + path_width + new_left_wall.get_polygon().top_section.top_edge.right_coord.x 
	wall.get_polygon().top_section.bottom_edge.right_coord.x = -320 + path_width + new_left_wall.get_polygon().top_section.bottom_edge.right_coord.x
	wall.get_polygon().mid_section.top_edge.right_coord.x = -320 + path_width + new_left_wall.get_polygon().mid_section.top_edge.right_coord.x
	return wall

func get_wall_range(x_coord: float) -> float:
	return clamp(rng.randf_range(x_coord - current_path_range, x_coord + current_path_range), 0, 320-path_width)

func set_data(data):
	path_width = data.path_width
	var signature = str(data)
	if signature == active_data_signature:
		return

	active_data_signature = signature
	forced_path_x_coord = data.path_x_coord if data.has("path_x_coord") else null
	target_path_x_coord = data.target_path_x_coord if data.has("target_path_x_coord") else null

func get_path_width():
	return rng.randi_range(min_width, max_width)

func get_parameters():
	return {
		'path_width': get_path_width()
	}

func _get_forced_lower_rndpoint() -> float:
	if target_path_x_coord == null:
		return forced_path_x_coord
	return move_toward(float(forced_path_x_coord), float(target_path_x_coord), current_path_range)

func set_current_meander_range(new_range: float) -> void:
	current_path_range = max(0.0, new_range)

func get_max_meander_range() -> float:
	return float(path_range)

func get_current_meander_range() -> float:
	return current_path_range
