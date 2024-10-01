class_name WallController
extends Node

const LEFT_EDGE = 0
const RIGHT_EDGE = 320
const SCREEN_HEIGHT = 200
const WALL_HEIGHT = 200
const WALL_WIDTH = 110

@export var wall_speed: float = 100.0
@export var nr_of_pieces: int = 3

var WallScene = preload("res://game/items/walls/wall.tscn")
var initial_left_shape = [
	Vector2(0, 0),
	Vector2(WALL_WIDTH, 0),
	Vector2(WALL_WIDTH, WALL_HEIGHT / 2),
	Vector2(WALL_WIDTH, WALL_HEIGHT),
	Vector2(0, WALL_HEIGHT),
	Vector2(0, WALL_HEIGHT / 2)
]
var initial_right_shape = [
	Vector2(-WALL_WIDTH, 0),
	Vector2(0, 0),
	Vector2(0, WALL_HEIGHT / 2),
	Vector2(0, WALL_HEIGHT),
	Vector2(-WALL_WIDTH, WALL_HEIGHT),
	Vector2(-WALL_WIDTH, WALL_HEIGHT / 2)
	]
var wall_spacing: float = WALL_HEIGHT/2
@onready var left_walls: Array = []
@onready var right_walls: Array = []
@onready var wall_component_controller: WallComponentController = $WallComponentController

func _ready():
	initialize_pieces()
	wall_component_controller.set_type("path")
	wall_component_controller.set_type_data(200)

func initialize_pieces():
	wall_component_controller.left_indices = [1, 2, 3]
	wall_component_controller.right_indices = [0, 5, 4]

	for peace_nr in range(nr_of_pieces):
		var peace_height = SCREEN_HEIGHT/(nr_of_pieces - 1)
		left_walls.append(make_wall(Vector2(LEFT_EDGE, peace_nr * peace_height), initial_left_shape))
		right_walls.append(make_wall(Vector2(RIGHT_EDGE, peace_nr * peace_height), initial_right_shape))

func _process(_delta: float):
	move_walls(wall_speed * _delta)

	if left_walls[nr_of_pieces - 1].position.y > 200:
		make_next_walls(left_walls, right_walls)

func make_wall(position: Vector2, initial_shape: Array) -> Wall:
	var new_wall = WallScene.instantiate()
	new_wall.position = position
	add_child(new_wall)
	new_wall.initialize_shape(initial_shape)
	return new_wall

func move_walls(speed: float):
	for wall in left_walls:
		wall.move_down(speed)
	for wall in right_walls:
		wall.move_down(speed)

func make_next_walls(left_wall_array: Array, right_wall_array: Array):
	var old_left_wall = left_wall_array[0]
	var new_left_wall = left_wall_array[nr_of_pieces - 1]

	var old_right_wall = right_wall_array[0]
	var new_right_wall = right_wall_array[nr_of_pieces - 1]

	var walls = wall_component_controller.get_walls(old_left_wall, new_left_wall, old_right_wall, new_right_wall)

	new_left_wall = walls.left
	new_right_wall = walls.right

	new_left_wall.position.y = old_left_wall.position.y - wall_spacing
	new_right_wall.position.y = old_right_wall.position.y - wall_spacing

	left_wall_array = shift_walls(left_wall_array, new_left_wall)
	right_wall_array = shift_walls(right_wall_array, new_right_wall)

func shift_walls(wall_array:Array, new_wall:Wall) -> Array:
	for i in range(nr_of_pieces - 1, 0, -1):
		wall_array[i] = wall_array[i - 1]

	wall_array[0] = new_wall
	return wall_array
