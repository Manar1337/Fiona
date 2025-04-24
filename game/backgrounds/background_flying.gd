class_name LandscapeBackground

extends ParallaxBackground

@export var speed:int = 0
@export var start_position:Vector2 = Vector2.ZERO


@onready var background_layer = $BackgroundLayer as ParallaxLayer
@onready var background: TileMapLayer = $BackgroundLayer/Background

var is_moving = true

func _process(delta):
	if is_moving:
		background_layer.motion_offset.x -= speed * delta

func set_speed(new_speed:int):
	speed = new_speed

func stop():
	is_moving = false

func start():
	is_moving = true

func set_position(new_position:float):
	background_layer.motion_offset.x = new_position

func set_random_position():
	var random_pos = randf_range(0, get_background_width() * 8)
	set_position(random_pos)


func get_background_width():
	return background.get_used_rect().size.x
