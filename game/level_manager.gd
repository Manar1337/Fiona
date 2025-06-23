extends Node
@onready var level_holder: Node = $"../LevelHolder"
@onready var game: Node = $".."

var previous_level_name: String = ""
var current_max_level: int = 2

var LT = LevelConstants.LevelType

var levels_dir: Dictionary = {
	LT.START: {"path": "res://game/levels/start_screen/start_screen.tscn"},
	LT.FLYING: {"path": "res://game/levels/flying_level/level"},
	LT.WALKING: {"path": "res://game/levels/walking_level/level"},
	LT.DEATH: {"path": "res://game/levels/death_level/death_level.tscn"},
	LT.POEM: {"path": "res://game/levels/poem_level/poem_level.tscn"},
	LT.HIGH_SCORE: {"path": "res://game/levels/high_score_level/high_score_level.tscn"},
}

const DEFAULT_LEVEL_INDEX: int = 0

func _ready():
	SignalHandler.connect("level_requested", request_level)
	SignalHandler.connect("next_level_requested", request_next_level)
	SignalHandler.connect("restart_game", _on_restart_game)

	GameData.level = DEFAULT_LEVEL_INDEX

func request_level(level_type: LevelConstants.LevelType, level_nr: int):
	match level_type:
		LT.START:
			SignalHandler.show_gui.emit(false)
			load_level(LT.START, 0)
		LT.FLYING:
			SignalHandler.show_gui.emit(true)
			GameData.level = level_nr
			load_level(level_type, level_nr)
		LT.WALKING:
			SignalHandler.show_gui.emit(true)
			GameData.level = level_nr
			load_level(level_type, level_nr)
		LT.DEATH:
			SignalHandler.show_gui.emit(true)
			load_level(level_type, level_nr)
		LT.POEM:
			SignalHandler.show_gui.emit(false)
			GameData.poem_level = level_nr
			load_level(level_type, level_nr)
		LT.HIGH_SCORE:
			SignalHandler.show_gui.emit(false)
			GameData.high_score_visible = true
			load_level(level_type, level_nr)


func request_next_level():
	var next_level = GameData.level + 1
	if next_level > current_max_level:
		next_level = 1
	var next_level_structure = LevelConstants.level_structure.get("level_" + str(next_level ))
	load_level(next_level_structure["type"], next_level_structure["number"])
		

func load_level(level_type: LevelConstants.LevelType, level_nr: int):
	if GameData.current_level_node:
		unload_current_level()
	
	if levels_dir.has(level_type):
		var level_path: String
		if level_type == LT.FLYING:
			level_path = levels_dir[level_type].path + "_" + str(level_nr) + ".tscn"
		else: if level_type == LT.WALKING:
			level_path = levels_dir[level_type].path + "_" + str(level_nr) + ".tscn"
		else :
			level_path = levels_dir[level_type].path

		var level_scene: PackedScene = load(level_path)
		if level_scene:
			GameData.current_level_node = level_scene.instantiate()
			level_holder.add_child(GameData.current_level_node)

			if GameData.current_level_node.has_method("on_enter"):
				GameData.current_level_node.on_enter()
			previous_level_name = str(level_type)
			GameData.level = level_nr
			GameData.previous_level_type = GameData.current_level_type
			GameData.current_level_type = level_type
			SignalHandler.level_changed.emit(GameData.level)
		else:
			print("Failed to load level scene: ", level_path)
	else:
		print("Invalid level type: ", str(level_type))

func unload_current_level():
	if GameData.current_level_node.has_method("on_exit"):
		GameData.current_level_node.on_exit()
	GameData.current_level_node.queue_free()

func _on_restart_game():
	if GameData.current_level_node:
		level_holder.remove_child(GameData.current_level_node)
		GameData.current_level_node.queue_free()
		GameData.current_level_node = null
