extends Node

@export var start_lives: int = 4
@export var start_health: int = 2000


@onready var level_manager: Node = $LevelManager
@onready var gui: Node = $GUI

var poem_level: int = 0

func _ready():
	GameData.score = 0
	GameData.health = start_health
	GameData.lives = start_lives
	# GameData.level_requested.emit("start")
	GameData.level = 2

func _input(_event):
	if Input.is_action_just_pressed("pause_game"):
		print("Pause is: ",str(GameData.is_paused))
		GameData.pauseGame(!GameData.is_paused)
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		swap_fullscreen_mode()

	if Input.is_action_just_pressed("next_level"):
		GameData.level = GameData.level + 1

	if Input.is_action_just_pressed("show_poem"):
		GameData.level_requested.emit("poem")

func swap_fullscreen_mode():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
