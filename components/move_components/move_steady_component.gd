class_name MoveSteadyComponent
extends Node

@export var speed: float = 50.0
@export var direction: Vector2 = Vector2.LEFT

var mode = "steady"

func calculate_movement(delta):
	return (direction * delta).normalized() * speed

func set_data(data: Array):
	direction = data[0]

func set_speed(new_speed):
	speed = new_speed

func set_direction(new_direction):
	direction = new_direction
