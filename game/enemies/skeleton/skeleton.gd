extends Node2D

@onready var move_component = $MoveComponent

var speed = -32 + (randf() * -32)
func _ready():
	move_component.velocity.x = speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
