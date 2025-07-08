class_name MoveControlledComponent
extends MoveComponentMode

var direction: Vector2 = Vector2.ZERO
var mode = "controlled"
var control_active = true

func calculate_movement(delta):
	if(!control_active):
		return Vector2.ZERO
	var input_direction = Vector2.ZERO

	var input_axisX = Input.get_axis("ui_left","ui_right")
	var input_axisY = Input.get_axis("ui_up","ui_down")

	if input_axisX < 0 : input_direction += Vector2.LEFT
	if input_axisX > 0 : input_direction += Vector2.RIGHT
	if input_axisY < 0 : input_direction += Vector2.UP
	if input_axisY > 0 : input_direction += Vector2.DOWN
	set_direction(input_direction)

	return (direction * delta).normalized() * speed

func set_data(_data: Array):
	control_active = _data[0]

func set_direction(new_direction):
	direction = new_direction
