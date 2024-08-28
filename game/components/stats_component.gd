class_name StatsComponent
extends Node

@export var magic: int:
	set(value):
		magic = value


@export var score: int = 0:
	set(value):
		score = value

func take_damage(amount: int):
	magic -= amount


func add_score(points: int):
	score += points
	GameData.score += score
