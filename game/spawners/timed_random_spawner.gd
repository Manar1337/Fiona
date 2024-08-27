class_name TimedRandomSpawner

extends Node

signal targeting_enemy_spawned(enemy)

@export var what_to_spawn: PackedScene

@export_group("Timer")
@export var timer_max: float
@export var timer_min: float

@export_group("Targets")
@export var target_player: bool = false

@onready var spawner_component = $SpawnerComponent as SpawnerComponent
@onready var timer = $Timer as Timer

func _ready():
	timer.timeout.connect(handle_spawn)

func handle_spawn():
	spawner_component.what_to_spawn = what_to_spawn
	var level = GameData.current_level
	var spawnpos = getSpawnpos()
	var enemy = spawner_component.spawn(spawnpos, level)
	if target_player:
		targeting_enemy_spawned.emit(enemy)
	timer.set_wait_time(randf_range(timer_min,timer_max))
	timer.start()

func getSpawnpos():
	return Vector2(0,0)
