class_name WallSequence
extends Node

var segments = []

func add_segment(segment: WallSegment):
	segments.append(segment)

func get_first_segment() -> WallSegment:
	return segments[0]

func lower_first_segment_count():
	get_first_segment().decrease_count()
	if segments[0].count <= 0:
		drop_first_segment()

func drop_first_segment():
	segments.pop_front()

func show_sequence():
	var counter = 1
	for segment in segments:
		segment.show_segment(counter)
		counter += 1
