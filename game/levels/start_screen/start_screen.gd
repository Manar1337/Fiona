class_name StartScreen

extends Node

@export var start_level: int = 1

func _input(_event):
	if Input.is_action_just_pressed("fire"):
		GameData.level = start_level

func set_start_level(level: int):
	start_level = level
