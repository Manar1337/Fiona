extends Node

@onready var level_holder: Node = $"../LevelHolder"

var current_level: Node = null
var levels: Array[Dictionary] = [
	{"type": "flying", "path": "res://game/levels/level_1.tscn"},
	{"type": "poem", "path": "res://game/levels/poem_level.tscn"},
	{"type": "walking", "path": "res://game/levels/level_2.tscn"},
	{"type": "poem", "path": "res://game/levels/poem_level.tscn"},
]

const DEFAULT_LEVEL_INDEX: int = 0

func _ready():
	load_level(DEFAULT_LEVEL_INDEX)
	GameData.connect("level_changed",load_level)

func load_level(level_index: int):
	if current_level:
		if current_level.has_method("on_exit"):
			current_level.on_exit()
		current_level.queue_free()

	if level_index >= 0 and level_index < levels.size():
		var level_data = levels[level_index]
		var level_scene: PackedScene = load(level_data["path"])
		if level_scene:
			current_level = level_scene.instantiate()
			level_holder.add_child(current_level)
			if level_data["type"] == "poem":
				GameData.poem_level = floor(level_index / 2.0) + 1
				GameData.showGui(false)
			else:
				GameData.showGui(true)
				GameData.showDeathMessage(false)

			if current_level.has_method("on_enter"):
				current_level.on_enter()
			GameData.current_level = current_level
		else:
			print("Failed to load level scene: ", level_data["path"])
	else:
		print("Invalid level index: ", level_index)
