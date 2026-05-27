class_name WallComponentController
extends Node

var types = {} # Map type names to instances
var wall_sequence: WallSequence = WallSequence.new()
var wall_data = null
var current_wall_component: WallComponent = null
var rng = RandomNumberGenerator.new()
var extreme_wall_side: int = 0
var extreme_last_end_x = null
var last_segment_end_x = null
var last_segment_width = null
var max_transition_center_delta: float = 24.0
var max_transition_width_delta: int = 18
var distance_travelled: float = 0.0
var forced_wall_type: String = ""

@export var difficulty_step_distance: float = 100.0
@export var path_start_ratio: float = 0.8
@export var path_range_step: float = 4.0
@export var drift_start_ratio: float = 0.85
@export var drift_step: float = 2.0

func _ready():
	rng.randomize()

	for wall_component in get_children():
		types[wall_component.type] = wall_component
	SignalHandler.death_tunnel_progress_changed.connect(_on_death_tunnel_progress_changed)
	_update_dynamic_difficulty()
	if wall_sequence.segments.size() > 0:
		current_wall_component = types[wall_sequence.get_first_segment().type]
	else:
		current_wall_component = types['path']

func get_current_wall_component():
	_ensure_sequence_has_segment()
	var current_wall_segment = wall_sequence.get_first_segment()
	# current_wall_segment.show_segment()
	var current_component = types[wall_sequence.get_first_segment().type]
	current_component.set_data(current_wall_segment.data)
	return current_component

func get_current_wall_type():
	return current_wall_component.get_type()

func set_data(data):
	wall_data = data

func make_next_wall_for_sequence():
	if not forced_wall_type.is_empty():
		add_wall_segment(forced_wall_type)
		return

	var wall_types = types.keys()
	var test_wall_type = TestSettings.get_next_tunnel_mode(wall_types)
	if not test_wall_type.is_empty():
		_update_dynamic_difficulty()
		add_wall_segment(test_wall_type)
		return

	var random_wall_types = wall_types.filter(func(wall_type: String): return wall_type != "straight" and wall_type != "exit")
	if random_wall_types.is_empty():
		random_wall_types = wall_types

	var random_type = ""
	while random_type == "":
		random_type = random_wall_types[rng.randi_range(0, random_wall_types.size() - 1)]
	_update_dynamic_difficulty()
	add_wall_segment(random_type)

func add_wall_segment(wall_type: String):
	if not types.has(wall_type):
		push_error("Error: Wall type '" + wall_type + "' was not set.")
		return

	var component  = types[wall_type]
	var segment = WallSegment.new(wall_type)
	var segment_data = component.get_parameters()
	if TestSettings.is_available() and TestSettings.extreme_wall_enabled:
		segment_data = _apply_extreme_wall_data(component, segment_data)

	segment_data = _apply_transition_limits(component, segment_data)
	
	segment.set_count(component.get_nr_of_segments())
	segment.set_data(segment_data)

	wall_sequence.add_segment(segment)

	current_wall_component = component
	_store_segment_exit(component, segment_data)

func get_first_wall_segment():
	_ensure_sequence_has_segment()
	return wall_sequence.get_first_segment()

func lower_first_wall_count():
	_ensure_sequence_has_segment()
	wall_sequence.lower_first_segment_count()
	if wall_sequence.segments.size() == 0:
		make_next_wall_for_sequence()
		show_sequence()
	# Update current_wall_component to the new first segment type
	if wall_sequence.segments.size() > 0:
		current_wall_component = types[wall_sequence.get_first_segment().type]

func drop_first_wall_segment():
	wall_sequence.drop_first_segment()
	# Update current_wall_component to the new first segment type
	if wall_sequence.segments.size() > 0:
		current_wall_component = types[wall_sequence.get_first_segment().type]

func show_sequence():
	wall_sequence.show_sequence()

func show_current_wall_segment():
	pass
	# get_first_wall_segment().show_segment()

func set_wall_data(segment: WallSegment) -> WallSegment:
	segment.set_data(types[segment.get_type()].get_parameters())
	return segment

func clear_sequence() -> void:
	wall_sequence.segments.clear()

func force_wall_type(wall_type: String) -> void:
	forced_wall_type = wall_type
	clear_sequence()

func clear_forced_wall_type() -> void:
	forced_wall_type = ""

func _ensure_sequence_has_segment() -> void:
	if wall_sequence.segments.size() == 0:
		make_next_wall_for_sequence()

func _apply_extreme_wall_data(component: WallComponent, data: Dictionary) -> Dictionary:
	if not data.has("path_width"):
		return data

	var path_width = int(data.path_width)
	var max_x = max(0.0, 320.0 - path_width)
	var start_x = _resolve_extreme_start_x(data, max_x)
	var target_x = 0.0 if extreme_wall_side == 0 else max_x
	extreme_wall_side = 1 - extreme_wall_side

	match component.get_type():
		"drift":
			data.path_x_coord = start_x
			data.drift = (target_x - start_x) / float(max(1, component.get_nr_of_segments()))
			extreme_last_end_x = clamp(start_x + data.drift * component.get_nr_of_segments(), 0.0, max_x)
		"path":
			var path_range = float(component.get("path_range"))
			data.path_x_coord = start_x
			data.target_path_x_coord = target_x
			extreme_last_end_x = start_x
			for _i in range(component.get_nr_of_segments()):
				extreme_last_end_x = move_toward(extreme_last_end_x, target_x, path_range)
		"straight":
			data.path_x_coord = start_x
			extreme_last_end_x = start_x
		_:
			if data.has("path_x_coord"):
				data.path_x_coord = start_x
				extreme_last_end_x = start_x

	return data

func _resolve_extreme_start_x(data: Dictionary, max_x: float) -> float:
	if extreme_last_end_x != null:
		return clamp(float(extreme_last_end_x), 0.0, max_x)
	if data.has("path_x_coord"):
		return clamp(float(data.path_x_coord), 0.0, max_x)
	return max_x / 2.0

func _apply_transition_limits(component: WallComponent, data: Dictionary) -> Dictionary:
	if not data.has("path_width"):
		return data

	var path_width = int(data.path_width)
	if last_segment_width != null:
		var min_width = max(component.min_width, int(last_segment_width) - max_transition_width_delta)
		var max_width = min(component.max_width, int(last_segment_width) + max_transition_width_delta)
		path_width = clamp(path_width, min_width, max_width)
	data.path_width = path_width

	var max_x = max(0.0, 320.0 - float(path_width))
	var start_x = _resolve_segment_start_x(data, max_x)
	var end_x = start_x

	match component.get_type():
		"straight":
			data.path_x_coord = start_x
		"path":
			var target_x = data.get("target_path_x_coord", rng.randf_range(0.0, max_x))
			target_x = _clamp_center_target(float(target_x), start_x, max_x, _get_center_delta_limit(component))
			data.path_x_coord = start_x
			data.target_path_x_coord = target_x
			end_x = _simulate_path_end(component, start_x, target_x, component.get_nr_of_segments(), max_x)
		"drift":
			data.path_x_coord = start_x
			var raw_end_x = start_x + float(data.get("drift", 0.0)) * component.get_nr_of_segments()
			var clamped_end_x = _clamp_center_target(raw_end_x, start_x, max_x, _get_center_delta_limit(component))
			data.drift = (clamped_end_x - start_x) / float(max(1, component.get_nr_of_segments()))
			end_x = clamped_end_x
		"lane_target":
			data.path_x_coord = start_x
			data.lane_direction = _get_initial_lane_target_direction(component, start_x, path_width)
			end_x = _simulate_lane_target_end(component, start_x, path_width, int(data.lane_direction), component.get_nr_of_segments())
		"exit":
			data.path_x_coord = start_x
			end_x = start_x
		_:
			if data.has("path_x_coord"):
				data.path_x_coord = start_x

	if component.get_type() == "straight":
		end_x = start_x

	data["_resolved_end_x"] = clamp(end_x, 0.0, max_x)
	return data

func _resolve_segment_start_x(data: Dictionary, max_x: float) -> float:
	if last_segment_end_x != null:
		return clamp(float(last_segment_end_x), 0.0, max_x)
	if data.has("path_x_coord"):
		return clamp(float(data.path_x_coord), 0.0, max_x)
	return max_x / 2.0

func _clamp_center_target(target_x: float, start_x: float, max_x: float, max_delta: float = max_transition_center_delta) -> float:
	var min_target = max(0.0, start_x - max_delta)
	var max_target = min(max_x, start_x + max_delta)
	return clamp(target_x, min_target, max_target)

func _simulate_path_end(component: WallComponent, start_x: float, target_x: float, segments: int, max_x: float) -> float:
	var current_x = start_x
	var path_step = float(component.get("current_path_range"))
	for _i in range(max(1, segments)):
		current_x = move_toward(current_x, target_x, path_step)
	return clamp(current_x, 0.0, max_x)

func _store_segment_exit(component: WallComponent, data: Dictionary) -> void:
	if data.has("path_width"):
		last_segment_width = int(data.path_width)

	if data.has("_resolved_end_x"):
		last_segment_end_x = float(data["_resolved_end_x"])
		data.erase("_resolved_end_x")
		return

	if data.has("path_x_coord"):
		last_segment_end_x = float(data.path_x_coord)
		return

	last_segment_end_x = null

func _on_death_tunnel_progress_changed(distance_left: int, distance_total: int, _tunnel_speed: float) -> void:
	distance_travelled = max(0.0, float(distance_total - distance_left))
	_update_dynamic_difficulty()

func _update_dynamic_difficulty() -> void:
	var path_component: WallPathComponent = types.get("path")
	if path_component != null:
		path_component.set_current_meander_range(_get_current_path_range(path_component))

	var drift_component: WallDriftComponent = types.get("drift")
	if drift_component != null:
		var drift_range = _get_current_drift_range(drift_component)
		drift_component.set_current_drift_range(drift_range.x, drift_range.y)

func _get_current_path_range(path_component: WallPathComponent) -> float:
	var max_range = path_component.get_max_meander_range()
	if TestSettings.is_available() and TestSettings.extreme_wall_enabled:
		return max_range

	var start_range = max(1.0, floor(max_range * path_start_ratio))
	var steps = _get_difficulty_step_count()
	return min(max_range, start_range + steps * path_range_step)

func _get_current_drift_range(drift_component: WallDriftComponent) -> Vector2:
	var max_min_drift = drift_component.get_max_min_drift()
	var max_max_drift = drift_component.get_max_max_drift()
	if TestSettings.is_available() and TestSettings.extreme_wall_enabled:
		return Vector2(max_min_drift, max_max_drift)

	var start_min_drift = max(1.0, floor(max_min_drift * drift_start_ratio))
	var start_max_drift = max(start_min_drift, floor(max_max_drift * drift_start_ratio))
	var steps = _get_difficulty_step_count()
	return Vector2(
		min(max_min_drift, start_min_drift + steps * drift_step),
		min(max_max_drift, start_max_drift + steps * drift_step)
	)

func _get_difficulty_step_count() -> int:
	if difficulty_step_distance <= 0.0:
		return 0
	return int(floor(distance_travelled / difficulty_step_distance))

func _get_center_delta_limit(component: WallComponent) -> float:
	match component.get_type():
		"path":
			return float(component.get("current_path_range")) * component.get_nr_of_segments()
		"drift":
			return float(component.get("current_max_drift")) * component.get_nr_of_segments()
		_:
			return max_transition_center_delta

func _simulate_lane_target_end(component: WallComponent, start_x: float, path_width: int, lane_direction: int, segments: int) -> float:
	var current_lane_index = int(component.call("get_lane_index_for_x", start_x, float(path_width)))
	var current_direction = lane_direction
	for _i in range(max(1, segments)):
		var next_lane_index = current_lane_index + current_direction
		if next_lane_index < 0 or next_lane_index >= int(component.call("get_lane_count")):
			current_direction = -current_direction
			next_lane_index = current_lane_index + current_direction
		current_lane_index = clamp(next_lane_index, 0, int(component.call("get_lane_count")) - 1)
	return float(component.call("get_lane_x_for_index", current_lane_index, float(path_width)))

func _get_initial_lane_target_direction(component: WallComponent, start_x: float, path_width: int) -> int:
	var lane_index = int(component.call("get_lane_index_for_x", start_x, float(path_width)))
	var lane_count = int(component.call("get_lane_count"))
	if lane_index <= 0:
		return 1
	if lane_index >= lane_count - 1:
		return -1
	return 1 if rng.randi_range(0, 1) == 0 else -1
