class_name Cauldron

extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func splash():
	animated_sprite_2d.play("splash")
	GameData.spellpower += 300
	if GameData.spellpower >= 4000:
		GameData.level_requested.emit("poem")
