class_name WallComponent
extends Node

var left_indices = []
var right_indices = []
var left_wall: Wall = null
var right_wall: Wall = null
var type: String

func set_data(_data):
	pass

func get_parameters():
	# Return parameters needed for bridge wall generation
	return {}

func get_type():
	return type
