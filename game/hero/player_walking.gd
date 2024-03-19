extends CharacterBody2D


@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D
@onready var stats_component = $StatsComponent

func _ready():
	stats_component.health_changed.connect(get_hurt)

func get_hurt():
	print("Ouch")
