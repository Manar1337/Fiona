class_name TimedRandomMultispawner

extends TimedRandomSpawner

@export_group("Spawn positions")
@export var position_array: PackedVector2Array

func getSpawnpos():
	if position_array.is_empty():
		push_error("No spawn positions set in TimedRandomMultispawner.")
		return Vector2.ZERO
	return position_array[randi_range(0, position_array.size() - 1)]
