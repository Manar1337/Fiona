class_name WitchZap
extends Bullet

@onready var explosion_spawner: SpawnerComponent = $ExplosionSpawner

func on_hit():
	call_deferred("_spawn_explosion")

func _spawn_explosion():
	var magic = explosion_spawner.spawn(global_position, GameData.current_level)
	magic.add_to_group("magic")

	queue_free()