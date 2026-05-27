class_name WallDriftComponent
extends WallComponent

@export var min_drift: float = 8.0
@export var max_drift: float = 18.0

var path_x_coord: float = 0.0
var drift: float = 0.0
var active_data_signature: String = ""
var current_min_drift: float = 8.0
var current_max_drift: float = 18.0

func _ready():
	type = "drift"
	current_min_drift = min_drift
	current_max_drift = max_drift

func change_left_wall(wall: Wall) -> Wall:
	new_left_wall = wall

	var top_x = path_x_coord
	var mid_x = _advance_path_x()

	wall.get_polygon().top_section.top_edge.right_coord.x = top_x
	wall.get_polygon().top_section.bottom_edge.right_coord.x = mid_x
	wall.get_polygon().mid_section.top_edge.right_coord.x = mid_x
	return wall

func change_right_wall(wall: Wall) -> Wall:
	new_right_wall = wall

	wall.get_polygon().top_section.top_edge.right_coord.x = _to_right_wall_x(new_left_wall.get_polygon().top_section.top_edge.right_coord.x)
	wall.get_polygon().top_section.bottom_edge.right_coord.x = _to_right_wall_x(new_left_wall.get_polygon().top_section.bottom_edge.right_coord.x)
	wall.get_polygon().mid_section.top_edge.right_coord.x = _to_right_wall_x(new_left_wall.get_polygon().mid_section.top_edge.right_coord.x)
	return wall

func set_data(data):
	path_width = data.path_width
	var signature = str(data)
	if signature == active_data_signature:
		return

	active_data_signature = signature
	path_x_coord = data.path_x_coord
	drift = data.drift

func get_path_width():
	return rng.randi_range(min_width, max_width)

func get_parameters():
	var new_path_width = get_path_width()
	var max_x = 320 - new_path_width
	var drift_direction = -1.0 if rng.randi_range(0, 1) == 0 else 1.0
	return {
		"path_x_coord": rng.randf_range(0, max_x),
		"path_width": new_path_width,
		"drift": rng.randf_range(current_min_drift, current_max_drift) * drift_direction
	}

func _advance_path_x() -> float:
	var max_x = 320 - path_width
	path_x_coord = clamp(path_x_coord + drift, 0, max_x)

	if path_x_coord <= 0 or path_x_coord >= max_x:
		drift = -drift

	return path_x_coord

func _to_right_wall_x(left_x: float) -> float:
	return -320 + path_width + left_x

func set_current_drift_range(new_min_drift: float, new_max_drift: float) -> void:
	current_min_drift = max(0.0, min(new_min_drift, new_max_drift))
	current_max_drift = max(current_min_drift, new_max_drift)

func get_max_min_drift() -> float:
	return min_drift

func get_max_max_drift() -> float:
	return max_drift
