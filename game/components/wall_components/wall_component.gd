class_name WallComponent
extends Node

@export var min_width: int = 75
@export var max_width: int = 150
@export var min_segments: int = 3
@export var max_segments: int = 3

var left_indices = []
var right_indices = []
var new_left_wall: Wall = null
var new_right_wall: Wall = null
var rng = RandomNumberGenerator.new()
var nr_of_segments: int
var path_width: int
var type: String

func _init():
    rng.randomize()
    if min_width > max_width:
        push_warning("min_width should not be greater than max_width. Swapping values.")
        var temp = min_width
        min_width = max_width
        max_width = temp

    if min_segments > max_segments:
        push_warning("min_segments should not be greater than max_segments. Swapping values.")
        var temp = min_segments
        min_segments = max_segments
        max_segments = temp

    nr_of_segments = rng.randi_range(min_segments, max_segments)
    path_width = rng.randi_range(min_width, max_width)

func set_data(_data):
    pass

func get_parameters():
    return {}

func get_type():
    return type

func get_nr_of_segments():
    return nr_of_segments

func change_left_wall(wall:Wall) -> Wall:
    return wall

func change_right_wall(wall:Wall) -> Wall:
    return wall

