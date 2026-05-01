class_name MovePhysicalJumpComponent
extends MovePhysicalComponentMode

@export var jump_speed: float = 0.0
@export var direction: Vector2 = Vector2.ZERO

var mode = "jump"
var jumping = true

func calculate_movement(_delta):
    if jumping == true:
        jumping = false
        return direction * jump_speed
    return current_velocity

func set_data(data: Array):
    if data.size() > 0:
        jumping = data[0]
    else:
        print("Warning: No speed data provided for jump mode.")
    print("Jump mode data set with jump value: ", jumping)