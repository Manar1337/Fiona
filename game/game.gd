extends Node

@export var start_lives: int = 4
@export var start_spellpower: int = 2000

@onready var level_manager: Node = $LevelManager
@onready var gui: Node = $GUI

func _ready():
	# Connect signals
	SignalHandler.restart_game.connect(_on_restart_game)

	GameData.score = 0
	GameData.spellpower = start_spellpower
	GameData.lives = start_lives
	setup_game()

func _input(_event):
	if Input.is_action_just_pressed("pause_game"):
		SignalHandler.pauseGame(!GameData.is_paused)
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		swap_fullscreen_mode()

	if Input.is_action_just_pressed("next_level"):
		SignalHandler.next_level_requested.emit()

	if Input.is_action_just_pressed("show_poem"):
		SignalHandler.level_requested.emit(LevelConstants.LevelType.POEM, GameData.level)

	if Input.is_action_just_pressed("fly_up"):
		SignalHandler.everyoneShouldFlyUp()

func swap_fullscreen_mode():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func _on_restart_game():
	setup_game()

func setup_game():
	GameData.game_data_reset()
	if TestSettings.is_available():
		TestSettings.apply_start_values()
		TestSettings.request_start_target()
	else:
		GameData.score = 0
		GameData.spellpower = start_spellpower
		GameData.lives = start_lives
		SignalHandler.level_requested.emit(LevelConstants.LevelType.START, 0)
	SignalHandler.show_high_score.emit(false)
