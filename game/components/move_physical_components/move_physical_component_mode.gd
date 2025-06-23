class_name MovePhysicalComponentMode
extends Node

@export var speed: float = 0.0

func set_speed(new_speed):
    speed = new_speed

func uses_gravity():
    return true