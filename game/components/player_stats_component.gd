class_name PlayerStatsComponent
extends Node

signal no_magic()

@export var start_magic: int = 2000
var magic: int = start_magic:
	set(value):
		var was_alive := magic > 0
		magic = max(value, 0)
		GameData.spellpower = magic
		if was_alive and magic <= 0:
			no_magic.emit()

func take_damage(amount: int):
	if GameData.is_paused:
		return
	if magic <= 0:
		return
	if amount <= 0:
		return
	magic -= amount
