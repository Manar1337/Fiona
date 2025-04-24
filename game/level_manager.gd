extends Node

@onready var level_holder: Node = $"../LevelHolder"
@onready var game: Node = $".."

var current_level: Node = null
var previous_level_name: String = ""

var levels_dir: Dictionary = {
	"start": {"type": "start", "path": "res://game/levels/start_screen/start_screen.tscn"},
	"level_1": {"type": "flying", "path": "res://game/levels/flying_level/level_1.tscn", "poem_level": 1},
	"level_2": {"type": "walking", "path": "res://game/levels/walking_level/level_2.tscn", "poem_level": 2},
	"death": {"type": "death", "path": "res://game/levels/death_level/death_level.tscn"},
	"poem": {"type": "poem", "path": "res://game/levels/poem_level/poem_level.tscn"},
	"high_score": {"type": "high_score", "path": "res://game/levels/high_score_level/high_score_level.tscn"},
}

const DEFAULT_LEVEL_INDEX: int = 1

func _ready():
	GameData.connect("level_requested",request_level)

	GameData.level = DEFAULT_LEVEL_INDEX

func request_level(level_type: String):
	print("Requesting level: ", level_type)
	match level_type:
		"start":
			GameData.showGui(false)
			load_level("start")
		"level":
			GameData.showGui(true)
			GameData.showDeathMessage(false)
			load_level("level_" + str(GameData.level))
		"death":
			GameData.showGui(true)
			GameData.showDeathMessage(true)
			load_level("death")
		"poem":
			GameData.showGui(false)
			load_level("poem")
		"high_score":
			GameData.showGui(false)
			load_level("high_score")

func load_level(level_name: String):
	if current_level:
		unload_current_level()

	if levels_dir.has(level_name):
		var level_data = levels_dir[level_name]
		var level_scene: PackedScene = load(level_data["path"])
		if level_scene:
			current_level = level_scene.instantiate()
			level_holder.add_child(current_level)

			if current_level.has_method("on_enter"):
				current_level.on_enter()
			GameData.current_level = current_level
			previous_level_name = level_name
		else:
			print("Failed to load level scene: ", level_data["path"])
	else:
		print("Invalid level name: ", level_name)

func unload_current_level():
	if current_level.has_method("on_exit"):
		current_level.on_exit()
	current_level.queue_free()
