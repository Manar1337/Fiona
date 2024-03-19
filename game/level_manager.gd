extends Node

@onready var level_holder = $"../LevelHolder"

var current_level: Node = null
var level_paths = [
	"res://game/levels/flying_level.tscn",
	"res://game/levels/walking_level.tscn"
	]

func _ready():
	# Optionally, load the first level immediately, or handle this outside.
	load_level(1)

func load_level(level_index: int):
	if current_level:
		current_level.queue_free()

	if level_index >= 0 and level_index < level_paths.size():
		var level_scene = load(level_paths[level_index])
		print(level_scene)
		current_level = level_scene.instantiate()
		level_holder.add_child(current_level)
	else:
		print("Invalid level index: ", level_index)
