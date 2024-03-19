extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D


const SPEED = 75.0
const FLY_VELOCITY = 75.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y = 75

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX = Input.get_axis("ui_left", "ui_right")
	if directionX:
		velocity.x = directionX * SPEED
		print(velocity.x)
		if velocity.x > 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var directionY = Input.get_axis("ui_up", "ui_down")
	if directionY:
		if directionY != 0:
			velocity.y = directionY * FLY_VELOCITY
		else:
			velocity.y = 0
	if Input.is_action_just_released("ui_up"):
		velocity.y = 0
	move_and_slide()
