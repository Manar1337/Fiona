class_name MoveFallComponent
extends MoveComponentMode

@export var acceleration: float

var direction: Vector2
var mode = "fall"

func _ready():
	direction = Vector2.DOWN


func calculate_movement(delta):
	speed += acceleration
	return (direction * delta).normalized() * speed
