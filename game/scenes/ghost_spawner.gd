class_name GhostSpawner

extends TimedRandomMultispawner

signal ghost_spawned(new_instance)

func handle_spawn():
	spawner_component.what_to_spawn = what_to_spawn
	var spawnpos = position_array[randi_range(0,position_array.size()) - 1]

	var ghost = spawner_component.spawn(spawnpos)
	emit_signal("ghost_spawned", ghost)

	timer.set_wait_time(randf_range(timer_min,timer_max))
	timer.start()
