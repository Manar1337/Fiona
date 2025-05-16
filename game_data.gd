extends Node

# --- Signals ---

signal pause_game(onoff: bool)
signal score_changed(new_score: int)
signal health_changed(new_health: int)
signal lives_changed(new_lives: int)
signal level_changed(new_level: int)
signal level_requested(level_type: String)
signal freeze_everything(onoff: bool)
signal should_fly_up()
signal fly_up_finished
signal show_death_message(show_message: bool)
signal show_game_over_message(show_message: bool)
signal show_high_score(onoff: bool)
signal show_gui(will_show_gui: bool)

# --- Public State ---

var current_level
var is_paused: bool = false
var everything_frozen: bool = false
var has_fly_up_completed: bool = false

# --- High Score Table ---

var high_score_table := [
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
		score_changed.emit(score)

var health: int:
	get: return health
	set(value):
		health = value
		health_changed.emit(health)

var lives: int:
	get: return lives
	set(value):
		lives = value
		lives_changed.emit(lives)

var level: int:
	get: return level
	set(value):
		level = value
		level_changed.emit(level)
		level_requested.emit("level")

var poem_level: int = 0:
	get: return poem_level
	set(value):
		poem_level = value
		level_requested.emit("poem")

# --- UI/Gameplay Events ---

func showDeathMessage(show: bool) -> void:
	show_death_message.emit(show)

func showGameOverMessage(show: bool) -> void:
	show_game_over_message.emit(show)

func showHighScore(show: bool) -> void:
	show_high_score.emit(show)

func showGui(show: bool) -> void:
	show_gui.emit(show)

# --- Sprite Control ---

func freezeEverything(on: bool) -> void:
	everything_frozen = on
	freeze_everything.emit(on)

func everyoneShouldFlyUp() -> void:
	has_fly_up_completed = false
	should_fly_up.emit()

func flyUpFinished() -> void:
	has_fly_up_completed = true
	fly_up_finished.emit()

# --- Pause Control ---

func pauseGame(on: bool) -> void:
	is_paused = on
	get_tree().paused = on
	pause_game.emit(on)
