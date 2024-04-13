class_name TimedRandomSpawner

extends Node

@export var what_to_spawn: PackedScene

@export_group("Timer")
@export var timer_max: float
@export var timer_min: float

@export_group("Spawn position")
@export var spawn_top: float
@export var spawn_bottom: float
@export var spawn_left: float
@export var spawn_right: float

@onready var spawner_component = $SpawnerComponent as SpawnerComponent
@onready var timer = $Timer as Timer

var spawn_pos: Vector2

func _ready():
	timer.timeout.connect(handle_spawn)
	
func handle_spawn():
	spawner_component.what_to_spawn = what_to_spawn
	var spawnpos: Vector2 = Vector2(randf_range(spawn_left,spawn_right), randf_range(spawn_top,spawn_bottom))
	spawner_component.spawn(spawnpos)
	timer.set_wait_time(randf_range(timer_min,timer_max))
	timer.start()
