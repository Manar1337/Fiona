class_name MoveLungeComponent

extends Node

#Code copied from follow. Change it to lunge code from ghost

@export var speed: float = 50.0

var direction = Vector2.ZERO
var mode = "lunge"
var target: Node2D = null
var self_root: Node2D = null
var target_window = 8; #accuacy in targeting

func calculate_movement(delta):
	if target.global_position.y < self_root.global_position.y - target_window:
		direction = Vector2(-speed, -speed)
	elif target.global_position.y > self_root.global_position.y + target_window:
		direction = Vector2(-speed, speed)
	else: direction = Vector2(-speed, 0)
	return (direction * delta).normalized() * speed

func set_data(data: Array):
	target = data[0]
	self_root = data[1]

func set_speed(new_speed):
	speed = new_speed
