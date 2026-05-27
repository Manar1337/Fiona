class_name WallLaneTargetComponent
extends WallComponent

const LANE_POSITIONS := [0.25, 0.5, 0.75]

@export var min_lane_width: int = 105

var path_x_coord: float = 0.0
var current_lane_index: int = 1
var lane_direction: int = 1
var active_data_signature: String = ""

func _ready():
	type = "lane_target"

func change_left_wall(wall: Wall) -> Wall:
	new_left_wall = wall

	var target_lane_index = _get_next_lane_index()
	var target_x = _get_lane_x(target_lane_index)

	wall.get_polygon().top_section.top_edge.right_coord.x = path_x_coord
	wall.get_polygon().top_section.bottom_edge.right_coord.x = target_x
	wall.get_polygon().mid_section.top_edge.right_coord.x = target_x

	path_x_coord = target_x
	current_lane_index = target_lane_index
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
	current_lane_index = _get_nearest_lane_index(path_x_coord)
	lane_direction = int(data.get("lane_direction", _get_initial_direction(current_lane_index)))

func get_path_width():
	var lane_min_width = clamp(min_lane_width, min_width, max_width)
	return rng.randi_range(lane_min_width, max_width)

func get_parameters():
	return {
		"path_width": get_path_width()
	}

func get_lane_count() -> int:
	return LANE_POSITIONS.size()

func get_lane_index_for_x(x_coord: float, path_width_value: float) -> int:
	return _get_nearest_lane_index_for(x_coord, path_width_value)

func get_lane_x_for_index(lane_index: int, path_width_value: float) -> float:
	var max_x = max(0.0, 320.0 - path_width_value)
	var clamped_lane_index = clamp(lane_index, 0, get_lane_count() - 1)
	return max_x * LANE_POSITIONS[clamped_lane_index]

func _get_max_x() -> float:
	return max(0.0, 320.0 - path_width)

func _get_lane_x(lane_index: int) -> float:
	return get_lane_x_for_index(lane_index, path_width)

func _get_nearest_lane_index(x_coord: float) -> int:
	return _get_nearest_lane_index_for(x_coord, path_width)

func _get_nearest_lane_index_for(x_coord: float, path_width_value: float) -> int:
	var nearest_lane_index = 0
	var nearest_distance = INF
	for lane_index in range(get_lane_count()):
		var lane_x = get_lane_x_for_index(lane_index, path_width_value)
		var distance = absf(x_coord - lane_x)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_lane_index = lane_index
	return nearest_lane_index

func _get_initial_direction(lane_index: int) -> int:
	if lane_index <= 0:
		return 1
	if lane_index >= get_lane_count() - 1:
		return -1
	return 1 if rng.randi_range(0, 1) == 0 else -1

func _get_next_lane_index() -> int:
	var target_lane_index = current_lane_index + lane_direction
	if target_lane_index < 0 or target_lane_index >= get_lane_count():
		lane_direction = -lane_direction
		target_lane_index = current_lane_index + lane_direction
	return clamp(target_lane_index, 0, get_lane_count() - 1)

func _to_right_wall_x(left_x: float) -> float:
	return -320 + path_width + left_x
