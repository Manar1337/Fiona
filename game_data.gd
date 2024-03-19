extends Node

var score = 0
var health = 2000
var lives = 4
var level = 1

# Define signals
signal score_changed(new_score)
signal health_changed(new_health)
signal lives_changed(new_lives)
signal level_changed(new_level)


func set_score(value):
	score = value
	emit_signal("score_changed", score)

func set_health(value):
	health = value
	emit_signal("health_changed", health)

func set_lives(value):
	lives = value
	emit_signal("lives_changed", lives)

func set_level(value):
	level = value
	emit_signal("level_changed", level)
