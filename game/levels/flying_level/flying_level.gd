class_name FlyingLevel
extends Node

@export var flight_time: int = 0

@onready var player_flying: PlayerFlying = $PlayerFlying
@onready var landscape_background: LandscapeBackground = $LandscapeBackground
@onready var flight_timer: Timer = $FlightTimer
@onready var flying_enemy_generator: Node = $FlyingEnemyGenerator


func _ready() -> void:
	GameData.health = 2000
	flight_timer.wait_time = flight_time
	flight_timer.start()

	player_flying.has_landed.connect(_on_player_landed)
	GameData.connect("should_fly_up", _on_should_fly_up)

func _on_should_fly_up() -> void:
	stop_level()

	var flyables: Array = _gather_flyables(["enemies", "bullet", "magic"])
	flyables.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)

	await _fly_sprites_in_sequence(flyables)
	GameData.flyUpFinished()

func _fly_sprites_in_sequence(sprites: Array) -> void:
	for sprite in sprites:
		if sprite and sprite.has_method("fly_up"):
			sprite.fly_up()
			while is_instance_valid(sprite) and sprite.global_position.y + 32 > 0:
				await get_tree().process_frame

func _gather_flyables(groups: Array[String]) -> Array:
	var results: Array = []
	for group_name in groups:
		for node in get_tree().get_nodes_in_group(group_name):
			if node.has_method("fly_up"):
				results.append(node)
	return results


func stop_level() -> void:
	flight_timer.stop()
	landscape_background.stop()
	GameData.freezeSprites(true)

	# Stop any enemy spawners from continuing
	if flying_enemy_generator.has_method("stop_spawning"):
		flying_enemy_generator.stop_spawning()


func _on_player_landed() -> void:
	GameData.level_requested.emit("poem")

func handle_player_death(global_position: Vector2) -> void:
	stop_level()

	GameData.showDeathMessage(false)

	# Begin fly-up sequence
	GameData.has_fly_up_completed = false
	await _on_should_fly_up()

	# Play explosion
	player_flying._hide_player()
	player_flying.big_explosion_spawner.spawn(global_position, GameData.current_level)

	await get_tree().create_timer(1.0).timeout
	GameData.showDeathMessage(true)

	# Restart the level after delay (scene is not paused, so this works)
	await get_tree().create_timer(2.0).timeout

	# Only temporary since it actually should happen on the death level
	GameData.lives -= 1

	GameData.level = 1
