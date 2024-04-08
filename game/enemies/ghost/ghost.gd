extends CharacterBody2D

@onready var move_component = $MoveComponent
@onready var hitbox_component = $HitboxComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var timer = $Timer

enum directions {up, down, left, right}
const SPEED = 50.0
var direction:directions

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	move_component.velocity.y = -SPEED
	direction = directions.up
	hurtbox_component.hurt.connect(die.unbind(1))
	timer.timeout.connect(change_direction)

func _physics_process(_delta):
	move_and_slide()

func change_direction():
	direction = directions.values().pick_random()
	match direction:
		directions.up:
			move_component.velocity.x = 0
			move_component.velocity.y = SPEED
		directions.down:
			move_component.velocity.x = 0
			move_component.velocity.y = -SPEED
		directions.left:
			move_component.velocity.x = -SPEED
			move_component.velocity.y = 0
		directions.right:
			move_component.velocity.x = SPEED
			move_component.velocity.y = 0

func was_hit():
	die()
	
func die():
	queue_free()
