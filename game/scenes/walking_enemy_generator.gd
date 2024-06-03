extends Node2D

@onready var ghost_spawner = $GhostSpawner
@onready var player_walking: CharacterBody2D = $"../PlayerWalking"

const PLAYER_WALKING = preload("res://game/hero/player_walking.tscn")

func _ready():
	ghost_spawner.connect("ghost_spawned", _on_ghost_spawned)

func _on_ghost_spawned(ghost_instance):
	if ghost_instance.has_method("set_target"):
		ghost_instance.set_target(player_walking)
