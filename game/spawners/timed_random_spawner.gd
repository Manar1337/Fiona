class_name TimedRandomSpawner

extends Node

signal targeting_enemy_spawned(enemy)

@export var active: bool = true
@export var what_to_spawn: PackedScene

@export_group("Timer")
@export var timer_min: float
@export var timer_max: float

@export_group("Targets")
@export var target_player: bool = false

@onready var spawner_component = $SpawnerComponent as SpawnerComponent
@onready var timer = $Timer as Timer

func _ready():
	randomize()
	SignalHandler.freeze_everything.connect(_on_freeze_everything)
	if not _is_allowed_by_test_settings():
		active = false
		timer.stop()
		return
	timer.start(randf_range(timer_min, timer_max))
	timer.timeout.connect(_spawn_timer_timeout)

func validate() -> bool:
	if not what_to_spawn:
		push_error("No scene to spawn set in TimedRandomSpawner.")
		return false
	if not is_instance_valid(what_to_spawn):
		push_error("Invalid scene to spawn set in TimedRandomSpawner.")
		return false
	if not is_instance_valid(spawner_component):
		push_error("SpawnerComponent is not valid in TimedRandomSpawner.")
		return false
	if not is_instance_valid(timer):
		push_error("Timer is not valid in TimedRandomSpawner.")
		return false
	if not is_instance_valid(GameData.current_level_node):
		push_error("GameData.current_level_node is not valid in TimedRandomSpawner.")
		return false
	return true

func _spawn_timer_timeout():
	if not validate():
		return
	if not active:
		return
	if not _is_allowed_by_test_settings():
		active = false
		timer.stop()
		return
		
	spawner_component.what_to_spawn = what_to_spawn
	var level = GameData.current_level_node
	var spawnpos = getSpawnpos()
	var enemy = spawner_component.spawn(spawnpos, level)

	if target_player:
		targeting_enemy_spawned.emit(enemy)

	timer.set_wait_time(randf_range(timer_min, timer_max))
	timer.start()

func getSpawnpos():
	return Vector2(0,0)

func _on_freeze_everything(is_frozen):
	timer.paused = is_frozen

func _is_allowed_by_test_settings() -> bool:
	if not TestSettings.is_available():
		return true
	return TestSettings.is_spawner_enabled(what_to_spawn, GameData.current_level_type)
