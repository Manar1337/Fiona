extends Node

@export var start_level: int = 0
@export var start_lives: int = 4
@export var start_health: int = 2000

@onready var level_manager: Node = $LevelManager
@onready var gui: Node = $GUI

func _ready():
	GameData.score = 0
	GameData.health = start_health
	GameData.level = start_level
	GameData.lives = start_lives

func _input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		swap_fullscreen_mode()

	if Input.is_action_just_pressed("next_level"):
		level_manager.load_level(GameData.level + 1)

func swap_fullscreen_mode():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
