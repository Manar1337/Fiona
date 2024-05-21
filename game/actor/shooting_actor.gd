class_name ShootingActor

extends Actor

@export var has_target:bool = false

@export var spawn_time:int = 1
@export var random_spawntime:bool = false

@onready var spawner_component = $SpawnerComponent as SpawnerComponent
@onready var fire_rate_timer = $FireRateTimer
@onready var shooting_marker = $ShootingMarker as Marker2D

var bullet_speed = 100

var fire_lock = false
var target = null

func _ready():
	super()
	fire_rate_timer.timeout.connect(unlock_fire)

func set_target(new_target):
	target = new_target

func shoot():
	var bullet = spawner_component.spawn(shooting_marker.global_position)
	if has_target:
		bullet.set_direction(Vector2(target.global_transform.origin - self.global_transform.origin).normalized())
		bullet.set_speed(300)

	lock_fire()

func lock_fire():
	fire_lock = true
	var starttime = 0 if random_spawntime else spawn_time
	fire_rate_timer.start(randf_range(starttime, spawn_time))

func unlock_fire():
	fire_lock = false;
