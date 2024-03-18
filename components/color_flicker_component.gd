class_name ColorFlickerComponent
extends Node

@export var sprite: CanvasItem
@export var enabled = false

var original_sprite_color: Color

func _process(_delta):
	if !enabled: return
	changeColor()

func changeColor():
	sprite.self_modulate = Color(randf(),randf(),randf(),1)
