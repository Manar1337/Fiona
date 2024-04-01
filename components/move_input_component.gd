class_name MoveInputComponent
extends Node

@export var move_component: MoveComponent

var speed = 100

func _input(_event: InputEvent):
	var input_axisX = Input.get_axis("ui_left","ui_right")
	var input_axisY = Input.get_axis("ui_up","ui_down")
	move_component.velocity = Vector2(input_axisX * speed, input_axisY * speed)
