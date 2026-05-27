class_name Cauldron

extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func splash():
	print("Cauldron splash!")
	print(animated_sprite_2d.frame)
	print(animated_sprite_2d.animation)
	animated_sprite_2d.play("splash")
	print(animated_sprite_2d.animation)
	print(animated_sprite_2d.frame)
	GameData.spellpower += 300
