extends Node

@onready var player_walking: CharacterBody2D = $"../PlayerWalking"

func _ready():
	for spawner in get_children():
		if spawner is TimedRandomSpawner:
			spawner.connect("targeting_enemy_spawned", _on_targeting_enemy_spawned)

func _on_targeting_enemy_spawned(enemy_instance):
	if enemy_instance.has_method("set_target"):
		enemy_instance.set_target(player_walking)
