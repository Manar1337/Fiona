class_name WalkingLevel
extends Node

@export var magic_to_win: int = 4000

@onready var player_walking: PlayerWalking = $PlayerWalking
@onready var treasure: Node2D = $Treasure
@onready var cauldron: Cauldron = $Cauldron
@onready var walking_enemy_generator: Node = $WalkingEnemyGenerator

func _ready() -> void:
	GameData.spellpower = 2000
	SignalHandler.should_fly_up.connect(_on_should_fly_up)
	SignalHandler.spellpower_changed.connect(_on_spellpower_changed)

# func _input(_event):
	# if Input.is_action_just_pressed("fire"):
		# treasure.enabled(!treasure.visible)

func _on_should_fly_up() -> void:
	stop_level()

	await get_tree().process_frame

	var flyables: Array = _gather_flyables(["enemies", "bullet", "magic"])
	flyables.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)

	await _fly_game_objects_in_sequence(flyables)
	SignalHandler.flyUpFinished()

func _on_spellpower_changed(new_spellpower: int) -> void:
	if new_spellpower >= magic_to_win:
		start_win_sequence()

func _gather_flyables(groups: Array[String]) -> Array:
	var results: Array = []
	for group_name in groups:
		for node in get_tree().get_nodes_in_group(group_name):
			if node.has_node("FlyUpPhysicalComponent"):
				results.append(node)
	return results

func _fly_game_objects_in_sequence(game_objects: Array) -> void:
	for game_object in game_objects:
		if game_object and game_object.has_node("FlyUpPhysicalComponent"):
			var fly_up_component: FlyUpPhysicalComponent = game_object.get_node("FlyUpPhysicalComponent") as FlyUpPhysicalComponent
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

func start_win_sequence():
	stop_level()
	player_walking.color_flicker_component.enabled = true
	GameData.has_fly_up_completed = false
	await _on_should_fly_up()
	player_walking.color_flicker_component.enabled = false
	treasure.enabled(!treasure.visible)
	await get_tree().create_timer(5.0).timeout
	SignalHandler.level_requested.emit(LevelConstants.LevelType.POEM, GameData.level)
