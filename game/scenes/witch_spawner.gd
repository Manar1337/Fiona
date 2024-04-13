class_name WitchSpawner

extends TimedRandomSpawner

signal witch_spawned(new_instance)

func handle_spawn():
	spawner_component.what_to_spawn = what_to_spawn

	var spawnpos: Vector2 = Vector2(randf_range(spawn_left,spawn_right), randf_range(spawn_top,spawn_bottom))

	var witch = spawner_component.spawn(spawnpos)
	emit_signal("witch_spawned", witch)
	timer.set_wait_time(randf_range(timer_min,timer_max))
	timer.start()
