class_name GhostSpawner

extends TimedRandomMultispawner

signal ghost_spawned(new_instance)

func handle_spawn():
	spawner_component.what_to_spawn = what_to_spawn
	if position_array.is_empty():
		push_error("No spawn positions set in GhostSpawner.")
		return
	var spawnpos = position_array[randi_range(0, position_array.size() - 1)]

	var ghost = spawner_component.spawn(spawnpos, GameData.current_level_node)
	ghost_spawned.emit(ghost)

	timer.set_wait_time(randf_range(timer_min,timer_max))
	timer.start()
