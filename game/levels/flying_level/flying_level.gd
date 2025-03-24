class_name FlyingLevel

extends Node

@onready var player_flying: Player = $PlayerFlying

func _ready() -> void:
	GameData.health = 2000
	player_flying.has_landed.connect(end_level)

func end_level():
	GameData.level_requested.emit("poem")
