class_name StatsComponent
extends Node

@export var start_magic: int = GameData.health
var magic: int = start_magic:
	set(value):
		magic = value
		GameData.health = magic
		if magic <= 0:
			no_magic.emit()

@export var lives: int = 4:
	set(value):
		lives = value
		GameData.lives = lives

@export var score: int = 0:
	set(value):
		score = value
		GameData.score = score

# Signals
signal no_magic()
# Core damage handling
func take_damage(amount: int):
	magic -= amount
	GameData.health = magic

func lose_life():
	lives -= 1
	GameData.lives = lives
	if lives <= 0:
		print("Game over")
	else:
		magic = start_magic
		GameData.health = magic

func add_score(points: int):
	score += points
	GameData.score = score
