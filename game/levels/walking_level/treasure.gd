class_name Treasure
extends Node2D

@onready var color_flicker_component: Node = $ColorFlickerComponent

func enabled(onoff:bool) -> void:
	visible = onoff
	color_flicker_component.enabled = onoff
