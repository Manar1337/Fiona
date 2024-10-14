# Wall.gd
class_name Wall
extends Area2D

const WALL_HEIGHT = 200
const SECTION_HEIGHT = 100
const WALL_WIDTH = 110

@export var color: Color = Color(1.0, 1.0, 1.0)
var wall_collide: CollisionPolygon2D
var wall_shape: Polygon2D
var sections: int = 2

var left_indices = []
var right_indices = []


func _ready():
	initialize_nodes()

func initialize_nodes():
	wall_collide = $WallCollide
	wall_shape = $WallShape
	wall_shape.color = color

func move_down(speed: float):
	self.position += Vector2(0, speed)

func get_shape() -> PackedVector2Array:
	if wall_shape == null:
		push_error("Error: wall_shape is null in get_shape()")
		return []
	return wall_shape.polygon

func set_shape(new_shape: PackedVector2Array):
	if wall_shape == null or wall_collide == null:
		push_error("Error: wall_shape or wall_collide is null in set_shape()")
		return
	wall_shape.polygon = new_shape
	wall_collide.polygon = new_shape

func initialize_shape(side: String):
	match side:
		"left":
			set_shape(make_left_shape())
		"right":
			set_shape(make_right_shape())
		_:
			push_error("Error: Invalid side in initialize_shape()")

func make_left_shape():
	if sections < 2:
		push_error("Error: sections must be at least 2.")
		return []
	
	var new_left_shape = [Vector2(0, 0), Vector2(WALL_WIDTH, 0)]
	var section_height = SECTION_HEIGHT
	for i in range(1, sections):
		new_left_shape.append(Vector2(WALL_WIDTH, section_height * i))

	new_left_shape.append(Vector2(WALL_WIDTH, WALL_HEIGHT))
	new_left_shape.append(Vector2(0, WALL_HEIGHT))

	for i in range(sections - 1, 0, -1):
		new_left_shape.append(Vector2(0, section_height * i))
		print(new_left_shape)

	return new_left_shape

func make_right_shape():
	if sections < 2:
		push_error("Error: sections must be at least 2.")
		return []
	
	var new_right_shape = [Vector2(-WALL_WIDTH, 0), Vector2(0, 0)]
	var section_height = SECTION_HEIGHT

	for i in range(1, sections):
		new_right_shape.append(Vector2(0, section_height * i))

	new_right_shape.append(Vector2(0, WALL_HEIGHT))
	new_right_shape.append(Vector2(-WALL_WIDTH, WALL_HEIGHT))

	for i in range(sections - 1, 0, -1):
		new_right_shape.append(Vector2(-WALL_WIDTH, section_height * i))
	return new_right_shape

func set_sections(new_sections: int):
	sections = new_sections
	left_indices = range(1, 1 + sections + 1)
	print(left_indices)

	right_indices = range(sections * 2 + 1, sections + 1, -1)
	right_indices.push_front(0)
	print(right_indices)

func get_sections():
	return sections

func get_left_indices():
	return left_indices

func get_right_indices():
	return right_indices
