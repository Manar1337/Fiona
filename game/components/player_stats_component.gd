class_name PlayerStatsComponent
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

func take_damage(amount: int):
	print("take damage: ", amount)
	magic -= amount
	GameData.health = magic
