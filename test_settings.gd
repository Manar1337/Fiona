extends Node

signal settings_changed

const TEST_OVERLAY_SCRIPT = preload("res://game/gui/test_overlay.gd")
const TEST_OVERLAY_LAYER_NAME := "TestOverlayLayer"

const TARGETS := [
	{"id": "start", "label": "Start", "type": "start", "level": 0},
	{"id": "poem_1", "label": "Poem 1", "type": "poem", "level": 1},
	{"id": "flying_1", "label": "Flying 1 (L1)", "type": "flying", "level": 1},
	{"id": "poem_2", "label": "Poem 2", "type": "poem", "level": 2},
	{"id": "walking_1", "label": "Platform 1 (L2)", "type": "walking", "level": 2},
	{"id": "poem_3", "label": "Poem 3", "type": "poem", "level": 3},
	{"id": "flying_2", "label": "Flying 2 (L3)", "type": "flying", "level": 3},
	{"id": "poem_4", "label": "Poem 4", "type": "poem", "level": 4},
	{"id": "walking_2", "label": "Platform 2 (L4)", "type": "walking", "level": 4},
	{"id": "poem_5", "label": "Poem 5", "type": "poem", "level": 5},
	{"id": "flying_3", "label": "Flying 3 (L5)", "type": "flying", "level": 5},
	{"id": "poem_6", "label": "Poem 6", "type": "poem", "level": 6},
	{"id": "walking_3", "label": "Platform 3 (L6)", "type": "walking", "level": 6},
	{"id": "poem_7", "label": "Poem 7", "type": "poem", "level": 7},
	{"id": "flying_4", "label": "Flying 4 (L7)", "type": "flying", "level": 7},
	{"id": "poem_8", "label": "Poem 8", "type": "poem", "level": 8},
	{"id": "walking_4", "label": "Platform 4 (L8)", "type": "walking", "level": 8},
	{"id": "poem_9", "label": "Poem 9", "type": "poem", "level": 9},
	{"id": "flying_5", "label": "Flying 5 (L9)", "type": "flying", "level": 9},
	{"id": "poem_10", "label": "Poem 10", "type": "poem", "level": 10},
	{"id": "walking_5", "label": "Platform 5 (L10)", "type": "walking", "level": 10},
	{"id": "poem_11", "label": "Poem 11", "type": "poem", "level": 11},
	{"id": "flying_6", "label": "Flying 6 (L11)", "type": "flying", "level": 11},
	{"id": "poem_12", "label": "Poem 12", "type": "poem", "level": 12},
	{"id": "walking_6", "label": "Platform 6 (L12)", "type": "walking", "level": 12},
	{"id": "death", "label": "Death", "type": "death", "level": 0},
]

const ENEMY_TYPES := {
	"flying": ["witch", "cloud", "bat", "ghost"],
	"walking": ["skeleton", "ghost", "foot", "walking_bat", "hand"],
}

const TUNNEL_MODE_ALIASES := {
	"1": "straight",
	"straight": "straight",
	"2": "path",
	"path": "path",
	"turn": "path",
	"turning": "path",
	"3": "drift",
	"drift": "drift",
	"drifts": "drift",
	"d": "drift",
	"4": "lane_target",
	"lanetarget": "lane_target",
	"lane_target": "lane_target",
	"lane-target": "lane_target",
	"lt": "lane_target",
	"w": "lane_target",
}

var start_target_id: String = "start"
var fiona_invulnerable: bool = false
var disable_high_score: bool = false
var skip_poems: bool = false
var auto_return_death: bool = false
var start_score: int = 0
var start_lives: int = 4
var start_spellpower: int = 2000
var walking_magic_to_win: int = 0
var tunnel_speed: float = 50.0
var tunnel_sequence_text: String = ""
var extreme_wall_enabled: bool = false

var enemy_all_enabled := {
	"flying": true,
	"walking": true,
}
var enemy_enabled := {
	"flying": {},
	"walking": {},
}

var _tunnel_sequence: Array[String] = []
var _tunnel_sequence_index: int = 0

func _ready() -> void:
	for group_name in ENEMY_TYPES.keys():
		for enemy_name in ENEMY_TYPES[group_name]:
			enemy_enabled[group_name][enemy_name] = true
	if is_available():
		call_deferred("_ensure_overlay")

func is_available() -> bool:
	return OS.has_feature("debug") or OS.has_feature("editor")

func _ensure_overlay() -> void:
	if not is_available():
		return
	var root = get_tree().root
	if root.has_node(TEST_OVERLAY_LAYER_NAME):
		return

	var layer = CanvasLayer.new()
	layer.name = TEST_OVERLAY_LAYER_NAME
	layer.layer = 100
	layer.process_mode = Node.PROCESS_MODE_ALWAYS
	root.add_child(layer)

	var test_overlay = TEST_OVERLAY_SCRIPT.new()
	test_overlay.name = "TestOverlay"
	layer.add_child(test_overlay)

func apply_start_values() -> void:
	if not is_available():
		return
	GameData.score = start_score
	GameData.lives = start_lives
	GameData.spellpower = start_spellpower

func request_start_target() -> void:
	request_target(start_target_id)

func request_target(target_id: String) -> void:
	var target = get_target(target_id)
	if target.is_empty():
		return

	match target.type:
		"start":
			SignalHandler.level_requested.emit(LevelConstants.LevelType.START, 0)
		"flying":
			SignalHandler.level_requested.emit(LevelConstants.LevelType.FLYING, target.level)
		"walking":
			SignalHandler.level_requested.emit(LevelConstants.LevelType.WALKING, target.level)
		"poem":
			SignalHandler.level_requested.emit(LevelConstants.LevelType.POEM, target.level)
		"death":
			SignalHandler.level_requested.emit(LevelConstants.LevelType.DEATH, GameData.level)

func reload_current_level() -> void:
	match GameData.current_level_type:
		LevelConstants.LevelType.START:
			SignalHandler.level_requested.emit(LevelConstants.LevelType.START, 0)
		LevelConstants.LevelType.POEM:
			SignalHandler.level_requested.emit(LevelConstants.LevelType.POEM, GameData.poem_level)
		_:
			SignalHandler.level_requested.emit(GameData.current_level_type, GameData.level)

func get_target(target_id: String) -> Dictionary:
	for target in TARGETS:
		if target.id == target_id:
			return target
	return {}

func get_start_target_index() -> int:
	for i in range(TARGETS.size()):
		if TARGETS[i].id == start_target_id:
			return i
	return 0

func set_enemy_enabled(group_name: String, enemy_name: String, enabled: bool) -> void:
	if enemy_enabled.has(group_name):
		enemy_enabled[group_name][enemy_name] = enabled
		settings_changed.emit()

func set_enemy_group_enabled(group_name: String, enabled: bool) -> void:
	if enemy_all_enabled.has(group_name):
		enemy_all_enabled[group_name] = enabled
		settings_changed.emit()

func is_spawner_enabled(scene: PackedScene, level_type: LevelConstants.LevelType) -> bool:
	if not is_available():
		return true

	var group_name = get_level_enemy_group(level_type)
	if group_name.is_empty():
		return true
	if not enemy_all_enabled.get(group_name, true):
		return false

	var enemy_name = get_enemy_name_from_scene(scene)
	return enemy_enabled.get(group_name, {}).get(enemy_name, true)

func get_level_enemy_group(level_type: LevelConstants.LevelType) -> String:
	match level_type:
		LevelConstants.LevelType.FLYING:
			return "flying"
		LevelConstants.LevelType.WALKING:
			return "walking"
		_:
			return ""

func get_enemy_name_from_scene(scene: PackedScene) -> String:
	if scene == null or scene.resource_path.is_empty():
		return ""
	return scene.resource_path.get_file().get_basename().to_lower()

func reset_tunnel_sequence() -> void:
	_tunnel_sequence = parse_tunnel_sequence(tunnel_sequence_text)
	_tunnel_sequence_index = 0

func get_next_tunnel_mode(available_types: Array) -> String:
	if not is_available():
		return ""
	if _tunnel_sequence.is_empty():
		reset_tunnel_sequence()
	if _tunnel_sequence.is_empty():
		return ""

	for i in range(_tunnel_sequence.size()):
		var mode = _tunnel_sequence[_tunnel_sequence_index]
		_tunnel_sequence_index = (_tunnel_sequence_index + 1) % _tunnel_sequence.size()
		if available_types.has(mode):
			return mode
	return ""

func parse_tunnel_sequence(sequence_text: String) -> Array[String]:
	var parsed: Array[String] = []
	var cleaned = sequence_text.replace("\"", "").replace("'", "")
	for raw_part in cleaned.split(",", false):
		var key = raw_part.strip_edges().to_lower()
		if TUNNEL_MODE_ALIASES.has(key):
			parsed.append(TUNNEL_MODE_ALIASES[key])
	return parsed

func notify_changed() -> void:
	settings_changed.emit()
