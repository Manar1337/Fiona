class_name WallSegment
extends Node

var type: String = "path" 
var count: int = 3
var data = {}

func _init(wall_type: String):
    type = wall_type

func get_type() -> String:
    return type

func get_count() -> int:
    return count

func set_count(new_count: int) -> void:
    count = new_count

func get_data() -> Dictionary:
    return data

func set_data(new_data: Dictionary) -> void:
    data = new_data

func decrease_count() -> void:
    count -= 1
    if count <= 0:
        queue_free()

func show_segment(nr:int = -1) -> void:
    if nr == -1:
        print("Segment: Type=", "%-10s" % type, " Count=", count, " Data=", data)
    else:
        print("Segment ", "%-3d" % nr, ": Type = ","%-10s" % type, " Count = ", count, " Data = ", data)
