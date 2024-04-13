extends CharacterBody2D

@onready var move_component = $MoveComponent
@onready var hitbox_component = $HitboxComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var move_timer = $MoveTimer as Timer
@onready var death_timer = $DeathTimer as Timer

enum directions {UP, DOWN, LEFT, RIGHT}
enum states {FLYING, DYING}

const SPEED = 50.0
var direction:directions
var state:states
var target = null

func _ready():
	move_component.velocity.y = -SPEED
	direction = directions.UP
	state = states.FLYING
	hurtbox_component.hurt.connect(was_hit)
	move_timer.timeout.connect(change_direction)
	death_timer.timeout.connect(die)

func _physics_process(_delta):
	move_and_slide()

func change_direction():
	if state != states.FLYING: return
	
	direction = directions.values().pick_random()
	match direction:
		directions.UP:
			move_component.velocity.x = 0
			move_component.velocity.y = SPEED
		directions.DOWN:
			move_component.velocity.x = 0
			move_component.velocity.y = -SPEED
		directions.LEFT:
			move_component.velocity.x = -SPEED
			move_component.velocity.y = 0
		directions.RIGHT:
			move_component.velocity.x = SPEED
			move_component.velocity.y = 0
func set_target(new_target):
	target = new_target

func was_hit(obstacle:HitboxComponent):
	if state != states.DYING:
		var deathdir = position.direction_to(target.position)
		move_component.velocity.x = deathdir.x * SPEED * 4
		move_component.velocity.y = deathdir.y * SPEED * 4

		state = states.DYING
		move_timer.stop()
		death_timer.start()
	elif obstacle.get_parent() == target:
		die()
	
func die():
	queue_free()
