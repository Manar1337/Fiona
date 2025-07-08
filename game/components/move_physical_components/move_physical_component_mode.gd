class_name MovePhysicalComponentMode
extends Node

@export var speed: float = 0.0

var current_velocity: Vector2 = Vector2.ZERO

func set_speed(new_speed):
    speed = new_speed

func set_current_velocity(new_velocity: Vector2):
    current_velocity = new_velocity
    pass

func uses_gravity():
    return true

func set_data(_data: Array):
    # This function can be overridden by subclasses to set specific data
    pass