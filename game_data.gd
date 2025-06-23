extends Node

# --- Public State ---

var current_level_node
var is_paused: bool = false
var everything_frozen: bool = false
var has_fly_up_completed: bool = false
var high_score_visible: bool = false
var current_level_type: LevelConstants.LevelType = LevelConstants.LevelType.START
var previous_level_type: LevelConstants.LevelType = LevelConstants.LevelType.START

# --- High Score Table ---

var default_high_score_table := [
	{ "name": "FIONA RIDES OUT", "score": "700000" },
	{ "name": "BAD BECKY",       "score": "600000" },
	{ "name": "GHOULIE GAIL",    "score": "500000" },
	{ "name": "EVIL EDNA!",      "score": "400000" },
	{ "name": "MAD GLAD",        "score": "300000" },
	{ "name": "DJINN JANET",     "score": "200000" },
	{ "name": "SINNING SUE",     "score": "100000" },
	{ "name": "?? PLEXAR ??",    "score": "0" },
]

# --- Properties ---

var score: int:
	get: return score
	set(value):
		score = value
		SignalHandler.score_changed.emit(score)

# Spellpower is called "spellpower" in the original code, but it is actually the health of the player
# It goes up when you put something in the cauldron, and down when you get hit.
var spellpower: int:
	get: return spellpower
	set(value):
		spellpower = value
		SignalHandler.spellpower_changed.emit(spellpower)

var lives: int:
	get: return lives
	set(value):
		lives = value
		SignalHandler.lives_changed.emit(lives)

var level: int = 0:
	get: return level
	set(value):
		level = value

var poem_level: int = 0:
	get: return poem_level
	set(value):
		poem_level = value

var high_score_table: Array = default_high_score_table:
	get: return high_score_table
	set(value):
		high_score_table = value


func game_data_reset():
	# Reset all game data to initial state
	score = 0
	spellpower = 2000
	level = 0
	poem_level = 0
	high_score_visible = false
	is_paused = false
	everything_frozen = false
	has_fly_up_completed = false
	current_level_type = LevelConstants.LevelType.START
	previous_level_type = LevelConstants.LevelType.START
