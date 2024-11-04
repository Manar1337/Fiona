class_name WallSequence
extends Node

var sequence = []

func add_wall_type(wall_type: String, count: int):
    sequence.append({'type': wall_type, 'count': count})

func pop_next():
    if sequence.size() > 0:
        return sequence.pop_front()
    else:
        return null

func is_empty():
    return sequence.size() == 0