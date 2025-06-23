class_name MovePhysicalComponent
extends Node

signal turn(direction)

@export var active: bool = true

@export var turning: bool = false

var modes = []
var mode = null
var is_moving = true
var is_hovering = false
var movement_velocity = Vector2.ZERO
var gravity: float = 0.0

func _ready():
	if not active: return
	for child in get_children():
		modes.append(child.mode)
	if modes != []:
		set_mode(modes[0])

func _physics_process(delta):
	if not active: return
	if mode == null: return
	if not is_moving: return
	movement_velocity = Vector2.ZERO

	movement_velocity += mode.calculate_movement(delta)

	if movement_velocity.x > 0:
		turn.emit("left")
	if movement_velocity.x < 0:
		turn.emit("right")
	owner.velocity = movement_velocity
	apply_gravity()



	# var directionY = Input.get_axis("ui_up", "ui_down")
	# if directionY:
	# 	if directionY != 0:
	#		owner.velocity.y = directionY * SPEED
	#	else:
	#		owner.velocity.y = 0
	# if Input.is_action_just_released("ui_up"):
	#	owner.velocity.y = 0
	owner.move_and_slide()

func apply_gravity():	
	if not mode.uses_gravity:
		return
	if not is_hovering && mode.uses_gravity():
		print("Applying gravity: ", gravity)
		owner.velocity.y += gravity

func set_mode(new_mode)	:
	assert(modes.has(new_mode), "Error: Movement mode '" + new_mode + "' was not set.")
	for child in get_children():
		if child.mode != new_mode: continue
		mode = child
		break

func set_gravity(new_gravity: float):
	gravity = new_gravity

func set_is_hovering(new_is_hovering: bool):
	is_hovering = new_is_hovering

func set_speed(new_speed):
	mode.set_speed(new_speed)

func set_mode_data(data):
	mode.set_data(data)

func set_movement_velocity(new_movement_velocity: Vector2):
	print("Setting movement velocity to: ", new_movement_velocity)
	movement_velocity = new_movement_velocity

func stop():
	is_moving = false
	owner.velocity = Vector2.ZERO
	
func start():
	is_moving = true
