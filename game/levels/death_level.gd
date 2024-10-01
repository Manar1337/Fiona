extends Node2D

@export var speed:int = 10
@onready var player_blasting: CharacterBody2D = $PlayerBlasting
@onready var wall_controller: WallController = $WallController

var topLeftShape = PackedVector2Array()
func _ready():
	pass

func _process(delta: float):
	wall_controller.move_walls(speed * delta)
