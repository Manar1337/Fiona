class_name WallController
extends Node

signal walls_moved

const LEFT_EDGE = 0
const RIGHT_EDGE = 320
const SCREEN_HEIGHT = 200
const WALL_HEIGHT = 200
const WALL_WIDTH = 110

@export var wall_speed: float = 100.0
@export var nr_of_pieces: int = 3

var wall_scene = preload("res://game/items/walls/wall.tscn")
var wall_spacing: float = WALL_HEIGHT / 2
var rng: RandomNumberGenerator
var current_wall_type: String = ""

@onready var left_walls: Array = []
@onready var right_walls: Array = []
@onready var wall_component_controller: WallComponentController = $WallComponentController

func _ready():
	initialize_pieces()
	rng = RandomNumberGenerator.new()

func initialize_pieces():
	if nr_of_pieces < 2:
		push_error("Number of pieces must be at least 2.")
		return

	var piece_height = SCREEN_HEIGHT / (nr_of_pieces - 1)

	for piece_nr in range(nr_of_pieces):
		left_walls.append(make_wall("left", Vector2(LEFT_EDGE, piece_nr * piece_height)))
		right_walls.append(make_wall("right", Vector2(RIGHT_EDGE, piece_nr * piece_height)))

func _process(_delta: float):
	move_walls(wall_speed * _delta)

	if is_wall_out_of_bounds(left_walls):
		make_next_walls(left_walls, right_walls)

func is_wall_out_of_bounds(walls: Array):
	return walls[nr_of_pieces - 1].position.y > SCREEN_HEIGHT

func make_wall(side: String, position: Vector2) -> Wall:
	var new_wall = wall_scene.instantiate()
	new_wall.position = position
	add_child(new_wall)
	new_wall.set_sections(3)
	new_wall.initialize_shape(side)
	return new_wall

func move_walls(speed: float):
	for wall in left_walls:
		wall.move_down(speed)
	for wall in right_walls:
		wall.move_down(speed)
	walls_moved.emit()

func make_next_walls(left_wall_array: Array, right_wall_array: Array):
	var wall_types = wall_component_controller.types.keys()
	rng.randomize()
	var random_type = current_wall_type

	while random_type == current_wall_type:
		random_type = wall_types[rng.randi_range(0, wall_types.size() - 1)]
	current_wall_type = random_type

	var random_count = rng.randi_range(3, 3)
	print(random_type, random_count)
	set_wall_data(random_type)
	wall_component_controller.add_wall_type(random_type, random_count)

	var old_left_wall = left_wall_array[0]
	var new_left_wall = left_wall_array[nr_of_pieces - 1]

	var old_right_wall = right_wall_array[0]
	var new_right_wall = right_wall_array[nr_of_pieces - 1]

	var walls = wall_component_controller.get_next_walls(old_left_wall, new_left_wall, old_right_wall, new_right_wall)

	if walls == null:
		# Handle the case when there are no more walls
		return

	new_left_wall = walls['left']
	new_right_wall = walls['right']

	new_left_wall.position.y = old_left_wall.position.y - wall_spacing
	new_right_wall.position.y = old_right_wall.position.y - wall_spacing

	shift_walls(left_wall_array, new_left_wall)
	shift_walls(right_wall_array, new_right_wall)

func set_wall_data(type):
	match type:
		"straight":
			wall_component_controller.set_data(50)
		"path":
			wall_component_controller.set_data(50)


func shift_walls(wall_array: Array, new_wall: Wall):
	wall_array.pop_back() # Remove the last element
	wall_array.insert(0, new_wall) # Insert at the beginning
