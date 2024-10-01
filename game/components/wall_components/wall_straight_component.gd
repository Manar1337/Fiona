class_name WallStraightComponent
extends WallComponent

var type = "straight"
var dificulity = 1

var left_indices:Array = []
var right_indices:Array = []

func get_left_wall(_old_left_wall: Wall, new_left_wall:Wall):
	left_wall = new_left_wall
	return new_left_wall

func get_right_wall(_old_right_wall:Wall, new_right_wall:Wall):
	right_wall = new_right_wall
	return new_right_wall

func set_data(_data):
	pass
