class_name WalkingLevel
extends Node

@onready var player_walking: PlayerWalking = $PlayerWalking
@onready var treasure: Node2D = $Treasure
@onready var cauldron: Cauldron = $Cauldron
@onready var walking_enemy_generator: Node = $WalkingEnemyGenerator


func _ready() -> void:
	GameData.spellpower = 2000
	SignalHandler.connect("should_fly_up", _on_should_fly_up)

func _input(_event):
	if Input.is_action_just_pressed("fire"):
		treasure.enabled(!treasure.visible)

func _on_should_fly_up() -> void:
	stop_level()

	await get_tree().process_frame

	var flyables: Array = _gather_flyables(["enemies", "bullet", "magic"])
	flyables.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)

	await _fly_game_objects_in_sequence(flyables)
	SignalHandler.flyUpFinished()

func _gather_flyables(groups: Array[String]) -> Array:
	print("Gathering flyables from groups: ", groups)
	var results: Array = []
	for group_name in groups:
		for node in get_tree().get_nodes_in_group(group_name):
			if node.has_node("FlyUpComponent"):
				results.append(node)
	return results

func _fly_game_objects_in_sequence(game_objects: Array) -> void:
	for game_object in game_objects:
		if game_object and game_object.has_node("FlyUpComponent"):
			var fly_up_component: FlyUpComponent = game_object.get_node("FlyUpComponent") as FlyUpComponent
			fly_up_component.fly_up()
			while is_instance_valid(game_object) and game_object.global_position.y + 32 > 0:
				await get_tree().process_frame

func handle_player_death(global_position: Vector2) -> void:
	stop_level()
	GameData.has_fly_up_completed = false
	await _on_should_fly_up()

	player_walking.hide_player()
	player_walking.big_explosion_spawner.spawn(global_position, GameData.current_level_node)

	await get_tree().create_timer(1.0).timeout
	SignalHandler.show_death_message.emit(true)

	await get_tree().create_timer(2.0).timeout
	SignalHandler.show_death_message.emit(false)

	SignalHandler.player_sent_to_hell.emit()
	# SignalHandler.show_death_message.emit(false)


func stop_level() -> void:
	SignalHandler.freezeEverything(true)

	if walking_enemy_generator.has_method("stop_spawning"):
		walking_enemy_generator.stop_spawning()
