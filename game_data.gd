extends Node

signal score_changed(new_score)
signal health_changed(new_health)
signal lives_changed(new_lives)
signal level_changed(new_level)
signal level_requested(level_type)

signal show_death_message(show_message)
signal show_game_over_message(show_message)
signal show_high_score(onoff)
signal show_gui(will_show_gui)

var current_level

var score:
	get:
		return score
	set(value):
		score = value
		score_changed.emit(score)

var health:
	get:
		return health
	set(value):
		health = value
		health_changed.emit(health)

var lives:
	get:
		return lives
	set(value):
		lives = value
		lives_changed.emit(lives)

var level:
	get:
		return level
	set(value):
		level = value
		level_changed.emit(level)
		level_requested.emit("level")

var poem_level = 0:
	get:
		return poem_level
	set(value):
		poem_level = value
		level_requested.emit("poem")

var high_score_table := [
	{"name": "FIONA RIDES OUT", "score": "700000"},
	{"name": "BAD BECKY", "score": "600000"},
	{"name": "GHOULIE GAIL", "score": "500000"},
	{"name": "EVIL EDNA!", "score": "400000"},
	{"name": "MAD GLAD", "score": "300000"},
	{"name": "DJINN JANET", "score": "200000"},
	{"name": "SINNING SUE", "score": "100000"},
	{"name": "?? PLEXAR ??", "score": "0"},
]

func showDeathMessage(show_message:bool):
	show_death_message.emit(show_message)

func showGameOverMessage(show_message:bool):
	show_game_over_message.emit(show_message)

func showHighScore(onoff:bool):
	show_high_score.emit(onoff)

func showGui(will_show: bool):
	show_gui.emit(will_show)
