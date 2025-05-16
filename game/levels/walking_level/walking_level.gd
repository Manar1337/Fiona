class_name WalkingLevel
extends Node

@onready var player_walking: PlayerWalking = $PlayerWalking
@onready var treasure: Node2D = $Treasure
@onready var cauldron: Cauldron = $Cauldron

func _ready() -> void:
	GameData.health = 2000
	GameData.connect("should_fly_up", _on_should_fly_up)


func _on_should_fly_up() -> void:
	pass
