class_name WallComponentController
extends Node

var types = {} # Map type names to instances
var wall_sequence: WallSequence = WallSequence.new()
var wall_data = null
var current_wall_component: WallComponent = null
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

	for wall_component in get_children():
		types[wall_component.type] = wall_component
	if wall_sequence.segments.size() > 0:
		current_wall_component = types[wall_sequence.get_first_segment().type]
	else:
		current_wall_component = types['path']

func get_current_wall_component():
	var current_wall_segment = wall_sequence.get_first_segment()
	current_wall_segment.show_segment()
	var current_component = types[wall_sequence.get_first_segment().type]
	current_component.set_data(current_wall_segment.data)
	return current_component

func get_current_wall_type():
	return current_wall_component.get_type()

func set_data(data):
	wall_data = data

func make_next_wall_for_sequence():
	var wall_types = types.keys()
	var random_type = ""
	while random_type == "":
		random_type = wall_types[rng.randi_range(0, wall_types.size() - 1)]
	add_wall_segment(random_type)

func add_wall_segment(wall_type: String):
	if not types.has(wall_type):
		push_error("Error: Wall type '" + wall_type + "' was not set.")
		return

	var component  = types[wall_type]
	var segment = WallSegment.new(wall_type)
	
	segment.set_count(component.get_nr_of_segments())
	segment.set_data(component.get_parameters())
	segment = set_wall_data(segment)

	wall_sequence.add_segment(segment)

	current_wall_component = component

func get_first_wall_segment():
	return wall_sequence.get_first_segment()

func lower_first_wall_count():
	wall_sequence.lower_first_segment_count()
	if wall_sequence.segments.size() == 0:
		print("Change sequence")
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
	get_first_wall_segment().show_segment()

func set_wall_data(segment: WallSegment) -> WallSegment:
	segment.set_data(types[segment.get_type()].get_parameters())
	return segment
	