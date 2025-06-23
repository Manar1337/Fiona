class_name PlayerStatsComponent
extends Node

signal no_magic()

@export var start_magic: int = 2000
var magic: int = start_magic:
	set(value):
		magic = value
		GameData.spellpower = magic
		if magic < 0:
			magic = 0
			GameData.spellpower = 0
			no_magic.emit()

func take_damage(amount: int):
	if GameData.is_paused:
		return
	if GameData.spellpower <= 0:
		return
	if amount <= 0:
		return
	magic -= amount
	GameData.spellpower = magic
