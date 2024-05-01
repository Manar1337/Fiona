class_name MoveFallComponent
extends Node

@export var acceleration: float

var direction: Vector2
var speed = 0;
var mode = "fall"

func _ready():
	direction = Vector2.DOWN

func calculate_movement(delta):
	speed += acceleration
	return (direction * delta).normalized() * speed
