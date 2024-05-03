class_name MoveInputComponent
extends Node

@export var speed: float = 50.0
@export var direction: Vector2 = Vector2.LEFT

var mode = "controlled"

var input_axisX = 0
var input_axisY = 0

func _input(_event: InputEvent):
	input_axisX = Input.get_axis("ui_left","ui_right")
	input_axisY = Input.get_axis("ui_up","ui_down")

func calculate_movement(delta):
	var movement = Vector2(input_axisX, input_axisY * delta).normalized() * speed
	print(movement)
	input_axisX = 0
	input_axisY = 0
	return movement

func set_data(data: Array):
	direction = data[0]

func set_speed(new_speed):
	speed = new_speed

func set_direction(new_direction):
	direction = new_direction
