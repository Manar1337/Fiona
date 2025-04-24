class_name Wall
extends Area2D

@export var color: Color = Color(1.0, 1.0, 1.0)

var wall_collide_polygon: CollisionPolygon2D
var wall_polygon: WallPolygon
var type: WallPolygon.WallPolygonType

func _ready() -> void:
    initialize_wall()

func initialize_wall() -> void:
    wall_collide_polygon = $WallCollidePolygon
    wall_polygon = $WallPolygon
    wall_polygon.color = color

func get_type() -> WallPolygon.WallPolygonType:
    return type

func set_type(new_type: WallPolygon.WallPolygonType) -> void:
    type = new_type
    wall_polygon.set_type(new_type)

func get_polygon() -> WallPolygon:
    return wall_polygon

func set_polygon(new_polygon: WallPolygon) -> void:
    wall_polygon = new_polygon