class_name Cauldron

extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func splash():
	animated_sprite_2d.play("splash")
	GameData.health += 300
	if GameData.health >= 4000:
		GameData.level_requested.emit("poem")
