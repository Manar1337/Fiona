class_name TimedRandomMultispawner

extends TimedRandomSpawner

@export_group("Spawn positions")
@export var position_array: PackedVector2Array

func getSpawnpos():
	return position_array[randi_range(0,position_array.size()) - 1]
