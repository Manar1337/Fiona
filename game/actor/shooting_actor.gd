class_name ShootingActor
extends Actor

@export var spawn_time: int = 1
@export var random_spawntime: bool = false
@export var bullet_speed: int = 100

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var shooting_marker: Marker2D = $ShootingMarker

var fire_lock: bool = false

func _ready():
	super()
	fire_rate_timer.timeout.connect(unlock_fire)
	if random_spawntime:
		fire_rate_timer.start(randf_range(0, spawn_time))
	else:
		fire_rate_timer.start(spawn_time)

func shoot():
	var bullet = spawner_component.spawn(shooting_marker.global_position)
	if has_target and is_instance_valid(target):
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		bullet.set_direction(direction)
		bullet.set_speed(bullet_speed)
	lock_fire()

func lock_fire():
	fire_lock = true
	fire_rate_timer.start(randf_range(0, spawn_time) if random_spawntime else float(spawn_time))

func unlock_fire():
	fire_lock = false
