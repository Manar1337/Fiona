class_name PlayerWalkingMovement
extends Node

@export var actor: CharacterBody2D

signal turn(direction)

const SPEED = 75.0
const FLY_VELOCITY = 75.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(_delta):
	if not actor.is_on_floor():
		actor.velocity.y = 75

	var directionX = Input.get_axis("ui_left", "ui_right")
	if directionX:
		actor.velocity.x = directionX * SPEED
		if actor.velocity.x > 0:
			emit_signal("turn","left")
		else:
			emit_signal("turn","right")
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, SPEED)

	var directionY = Input.get_axis("ui_up", "ui_down")
	if directionY:
		if directionY != 0:
			actor.velocity.y = directionY * FLY_VELOCITY
		else:
			actor.velocity.y = 0
	if Input.is_action_just_released("ui_up"):
		actor.velocity.y = 0
	actor.move_and_slide()

