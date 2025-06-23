class_name Tunnel
extends Node2D

@export var wall_speed: float = 10.0
@onready var wall_component_controller: WallComponentController = $WallComponentController

@onready var left_walls: =$LeftWalls as LeftWalls
@onready var right_walls: =$RightWalls as RightWalls

var is_moving: bool = true

func _ready() -> void:
	SignalHandler.connect("game_over", _on_game_over)
	for i in range(10):
		wall_component_controller.make_next_wall_for_sequence()

	wall_component_controller.show_sequence()
	
func _process(_delta: float):
	if is_moving:
		move_down(wall_speed * _delta)

func move_down(speed: float):
	self.position += Vector2(0, speed)
	if self.position.y >= 133:
		flip_walls()
		self.position.y = 0

func flip_walls() -> void:
	var current_wall_component: WallComponent = wall_component_controller.get_current_wall_component()
	wall_component_controller.lower_first_wall_count()
	left_walls.flip_walls(current_wall_component)
	right_walls.flip_walls(current_wall_component)

func stop_moving() -> void:
	is_moving = false

func _on_game_over() -> void:
	stop_moving()


