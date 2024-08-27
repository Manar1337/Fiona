class_name TimedRandomSinglespawner

extends TimedRandomSpawner

@export_group("Spawn position")
@export var spawn_top: float
@export var spawn_bottom: float
@export var spawn_left: float
@export var spawn_right: float

func _ready():
	super()

func getSpawnpos():
	return Vector2(randf_range(spawn_left,spawn_right),randf_range(spawn_top,spawn_bottom))
