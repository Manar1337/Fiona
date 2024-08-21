extends Node
@onready var level_manager = $LevelManager

func _ready():
	GameData.score = 0
	GameData.health = 2000
	GameData.level = 0
	GameData.lives = 4

func _input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		swap_fullscreen_mode()

	if Input.is_action_just_pressed("next_level"):
		level_manager.load_level(0)

func swap_fullscreen_mode():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
