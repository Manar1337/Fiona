extends Node

signal score_changed(new_score)
signal health_changed(new_health)
signal lives_changed(new_lives)
signal level_changed(new_level)
signal poem_level_changed(new_poem_level)

signal show_death_message(show_message)
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

var poem_level = 0:
	get:
		return poem_level
	set(value):
		poem_level = value
		poem_level_changed.emit(value)

func showDeathMessage(show_message:bool):
	show_death_message.emit(show_message)

func showGui(will_show: bool):
	show_gui.emit(will_show)
