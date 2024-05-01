class_name ShootingEnemy

extends Enemy

@export var has_target:bool = false

@onready var spawner_component = $SpawnerComponent as SpawnerComponent
@onready var fire_rate_timer = $FireRateTimer
@onready var shooting_marker = $ShootingMarker as Marker2D

enum fire_directions {UP, DOWN, LEFT, RIGHT}

var bullet_speed = 100

var fire_lock = false
var fire_direction = fire_directions.DOWN
var target = null

func set_target(new_target):
	target = new_target

func shoot():
	var bullet = spawner_component.spawn(shooting_marker.global_position)
	if has_target:
		bullet.set_direction(Vector2(target.global_transform.origin - self.global_transform.origin).normalized())
		bullet.set_speed(300)
	else:
		match fire_direction:
			fire_directions.UP:
				bullet.set_speed(Vector2(0,bullet_speed))
			fire_directions.DOWN:
				bullet.set_speed(Vector2(0,-bullet_speed))
			fire_directions.LEFT:
				bullet.set_speed(Vector2(-bullet_speed,0))
			fire_directions.RIGHT:
				bullet.set_speed(Vector2(bullet_speed,0))

	lock_fire()

func lock_fire():
	fire_lock = true
	fire_rate_timer.start(1)

func unlock_fire():
	fire_lock = false;
