class_name PositionClampComponent
extends Node2D

@export var actor: Node2D
@export var margin: = 12

var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
var viewport_scale = ProjectSettings.get_setting("display/window/stretch/scale")
var left_border = 0
var right_border = viewport_width / viewport_scale
var top_border = 0
var bottom_border = viewport_height / viewport_scale

func _process(_delta):
	actor.global_position.x = clamp(actor.global_position.x, left_border + margin, right_border - margin)
	actor.global_position.y = clamp(actor.global_position.y, top_border + margin, bottom_border - margin)
