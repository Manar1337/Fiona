class_name TimedRandomMultispawner

extends Node

@export var what_to_spawn: PackedScene

@export_group("Timer")
@export var timer_max: float
@export var timer_min: float

@export_group("Spawn positions")
@export var position_array: PackedVector2Array

@onready var spawner_component = $SpawnerComponent as SpawnerComponent
@onready var timer = $Timer as Timer

#var spawn_pos: Vector2

func _ready():
	timer.timeout.connect(handle_spawn)
	
func handle_spawn():
	spawner_component.what_to_spawn = what_to_spawn
	#var spawnpos: Vector2 = Vector2(randf_range(spawn_left,spawn_right), randf_range(spawn_top,spawn_bottom))
	#for spawnpos: Vector2 in position_array:
	var spawnpos = position_array[randi_range(0,position_array.size()) - 1]
	spawner_component.spawn(spawnpos)
	timer.set_wait_time(randf_range(timer_min,timer_max))
	timer.start()
