class_name MovePhysicalSteadyComponent
extends MovePhysicalComponentMode

@export var direction: Vector2

var mode = "steady"

func calculate_movement(delta):
	return (direction * delta).normalized() * speed

func set_data(data: Array):
	print("Set data in MovePhysicalSteadyComponent")
	direction = data[0]

func set_speed(new_speed):
	print("Set speed in MovePhysicalSteadyComponent")
	speed = new_speed

func set_direction(new_direction):
	print("Set direction in MovePhysicalSteadyComponent")
	direction = new_direction
