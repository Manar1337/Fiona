class_name MoveSteadyComponent
extends MoveComponentMode

@export var direction: Vector2

var mode = "steady"

func calculate_movement(delta):
	return (direction * delta).normalized() * speed

func set_data(data: Array):
	direction = data[0]

func set_direction(new_direction):
	direction = new_direction
