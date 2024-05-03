class_name MoveControlledComponent
extends Node

@export var speed: float = 50.0

var direction: Vector2 = Vector2.ZERO
var mode = "controlled"

func calculate_movement(delta):
	set_direction(Vector2.ZERO)
	var input_axisX = Input.get_axis("ui_left","ui_right")
	var input_axisY = Input.get_axis("ui_up","ui_down")

	if input_axisX < 0 : set_direction(Vector2.LEFT)
	if input_axisX > 0 : set_direction(Vector2.RIGHT)
	if input_axisY < 0 : set_direction(Vector2.UP)
	if input_axisY > 0 : set_direction(Vector2.DOWN)
	print(direction)
	return (direction * delta).normalized() * speed

func set_data(data: Array):
	direction = data[0]

func set_speed(new_speed):
	speed = new_speed

func set_direction(new_direction):
	direction = new_direction
