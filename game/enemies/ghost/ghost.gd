class_name Ghost

extends GravityActor

@onready var move_timer: Timer = $MoveTimer
@onready var death_timer: Timer = $DeathTimer
@onready var star_spawner: SpawnerComponent = $StarSpawner

enum directions {UP, DOWN, LEFT, RIGHT}
enum states {FLYING, DYING}

var direction:directions
var state:states

func _ready():
	super()
	move_timer.start(1)
	move_timer.timeout.connect(change_direction)
	death_timer.timeout.connect(die)

func change_direction():
	if state != states.FLYING: return

	direction = directions.values().pick_random()
	match direction:
		directions.UP:
			move_component.set_mode_data([Vector2(0,-1)])
		directions.DOWN:
			move_component.set_mode_data([Vector2(0,1)])
		directions.LEFT:
			move_component.set_mode_data([Vector2(-1,0)])
		directions.RIGHT:
			move_component.set_mode_data([Vector2(1,0)])

func was_hit(obstacle:HitboxComponent):
	if state != states.DYING:
		var deathdir = position.direction_to(target.position)
		move_component.set_speed(400)
		move_component.set_mode_data([deathdir])

		state = states.DYING
		move_timer.stop()
		death_timer.start()
	elif obstacle.get_parent() == target:
		die()

func die():
	star_spawner.spawn(self.global_position)
	queue_free()


