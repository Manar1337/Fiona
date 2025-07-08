class_name MovePhysicalControlledComponent
extends MovePhysicalComponentMode

var mode = "controlled"

var control_active = true
var direction: Vector2 = Vector2.ZERO

func calculate_movement(_delta):
	if not control_active:
		return Vector2.ZERO

	var input_direction = Vector2.ZERO

	var input_axisX = Input.get_axis("ui_left", "ui_right")
	var input_axisY = Input.get_axis("ui_up", "ui_down")

	if input_axisX < 0: input_direction += Vector2.LEFT
	if input_axisX > 0: input_direction += Vector2.RIGHT
	if input_axisY < 0: input_direction += Vector2.UP
	if input_axisY > 0: input_direction += Vector2.DOWN

	set_direction(input_direction)

	if input_direction == Vector2.ZERO:
		return Vector2.ZERO  # No movement if no input

	# Normalize the direction to ensure consistent speed
	input_direction = input_direction.normalized()
	return input_direction * speed

func set_speed(new_speed):
	speed = new_speed

func set_direction(new_direction):
	direction = new_direction

func set_data(data: Array):
	control_active = data[0]

func uses_gravity():
	return direction == Vector2.ZERO || direction == Vector2.LEFT || direction == Vector2.RIGHT
