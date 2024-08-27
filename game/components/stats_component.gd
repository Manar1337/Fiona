class_name StatsComponent
extends Node

signal no_magic()

@export var start_magic: int = 2000
var magic: int = start_magic:
	set(value):
		magic = value
		GameData.health = magic
		if magic < 0:
			magic = 0
			GameData.health = 0
			no_magic.emit()

@export var lives: int = 4:
	set(value):
		lives = value
		GameData.lives = lives

@export var score: int = 0:
	set(value):
		score = value
		GameData.score = score

func take_damage(amount: int):
	print("take damage: ", amount)
	magic -= amount
	GameData.health = magic

func lose_life():
	lives -= 1
	GameData.lives = lives
	if lives <= 0:
		print("Game over")
	else:
		magic = 0
		GameData.health = magic

func add_score(points: int):
	score += points
	GameData.score = score
