extends Node

signal score_changed(new_score)
signal health_changed(new_health)
signal lives_changed(new_lives)
signal level_changed(new_level)
signal show_deathmessage(show_message)

var score = 0:
	get:
		return score
	set(value):
		score = value
		score_changed.emit(score)

var health = 2000:
	get:
		return health
	set(value):
		health = value
		health_changed.emit(health)

var lives = 4:
	get:
		return lives
	set(value):
		lives = value
		lives_changed.emit(lives)

var level = 1:
	get:
		return level
	set(value):
		level = value
		level_changed.emit(level)

func show_death_message(show_message):
	show_deathmessage.emit(show_message)
