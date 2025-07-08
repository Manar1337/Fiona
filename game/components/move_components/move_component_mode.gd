class_name MoveComponentMode
extends Node

@export var speed: float = 0.0

func set_speed(new_speed):
	speed = new_speed

func set_data(_data: Array):
	# This function can be overridden by subclasses to set specific data
	pass