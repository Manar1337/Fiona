class_name CloudZap
extends Bullet

@onready var explosion_spawner: SpawnerComponent = $ExplosionSpawner

func on_hit():
	call_deferred("_spawn_explosion")

func _spawn_explosion():
	explosion_spawner.spawn(global_position, GameData.current_level)
	queue_free()