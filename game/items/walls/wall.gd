class_name Wall
extends Area2D

@export var color: Color = Color(1.0, 1.0, 1.0)
@onready var wall_collide: CollisionPolygon2D = $WallCollide
@onready var wall_shape: Polygon2D = $WallShape

func _ready():

	wall_shape.color = color

func move_down(speed: float):
	self.position += Vector2(0, speed)

func get_shape() -> PackedVector2Array:
	return wall_shape.polygon

func set_shape(new_shape: PackedVector2Array):
	wall_shape.polygon = new_shape
	wall_collide.polygon = new_shape

func initialize_shape(shape_points: Array):
	set_shape(PackedVector2Array(shape_points))
