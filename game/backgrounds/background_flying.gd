extends ParallaxBackground

@export var speed:int = 32
@onready var background_layer = $BackgroundLayer as ParallaxLayer

func _process(delta):
	background_layer.motion_offset.x -= speed * delta
