extends Node
@onready var level_manager = $LevelManager

func _ready():
	GameData.set_score(0)
	GameData.set_health(2000)
	GameData.set_level(1)
	GameData.set_lives(4)

func _input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		swap_fullscreen_mode()
	
	if Input.is_action_just_pressed("next_level"):
		print("next_level")
		level_manager.load_level(1)

func swap_fullscreen_mode():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
