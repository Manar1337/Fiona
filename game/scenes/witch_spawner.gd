class_name WitchSpawner

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
@onready var timer = $Timer

signal witch_spawned(new_instance)

var spawn_pos: Vector2
var target = null
var where_to_spawn = null

func _ready():
	timer.timeout.connect(handle_spawn)
	
func start_spawn(spawn_place):
	where_to_spawn = spawn_place
	timer.stop()
	timer.start()
	
func handle_spawn():
	spawner_component.what_to_spawn = what_to_spawn
	var witch = spawner_component.spawn(
			Vector2(randf_range(spawn_left,spawn_right), randf_range(spawn_top,spawn_bottom))
			
		)
	
	emit_signal("witch_spawned", witch)
	timer.set_wait_time(randf_range(timer_min,timer_max))
	timer.start()
