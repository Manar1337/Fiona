class_name MovePhysicalJumpComponent
extends MovePhysicalComponentMode

var mode = "jump"
var jumping = false

func calculate_movement(_delta):
    jumping = true
    return current_velocity

func set_data(data: Array):
    if data.size() > 0:
        speed = data[0]
    else:
        print("Warning: No speed data provided for jump mode.")
    print("Jump mode data set with speed: ", speed)