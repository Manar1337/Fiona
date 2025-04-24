extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func splash():
	animated_sprite_2d.play("splash")
