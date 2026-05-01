class_name WitchZap
extends Bullet

@onready var explosion_spawner: SpawnerComponent = $ExplosionSpawner

var _is_frozen: bool = false

func on_hit():
	call_deferred("_spawn_explosion")
	_spawn_explosion()

func _spawn_explosion():
	if _is_frozen:
		return 

	var magic = explosion_spawner.spawn(global_position, GameData.current_level_node)

	if GameData.everything_frozen:
		if magic.has_method("freeze"):
			magic.freeze()

	queue_free()
