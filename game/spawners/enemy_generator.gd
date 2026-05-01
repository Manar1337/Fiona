extends Node

@export var player: Node

func _ready():
	for spawner in get_children():
		if spawner is TimedRandomSpawner:
			spawner.targeting_enemy_spawned.connect(_on_targeting_enemy_spawned)

func _on_targeting_enemy_spawned(enemy_instance):
	if enemy_instance.has_method("set_target"):
		enemy_instance.set_target(player)

func stop_spawning():
	for spawner in get_children():
		if spawner.has_method("stop"):
			spawner.stop()