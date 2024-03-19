class_name PlayerWalkingMovement
extends Node

@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@export var actor: CharacterBody2D

const SPEED = 75.0
const FLY_VELOCITY = 75.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not actor.is_on_floor():
		actor.velocity.y = 75

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX = Input.get_axis("ui_left", "ui_right")
	if directionX:
		actor.velocity.x = directionX * SPEED
		if actor.velocity.x > 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
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

