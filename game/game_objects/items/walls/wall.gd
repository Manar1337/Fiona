class_name Wall
extends Area2D

@export var color: Color = Color(1.0, 1.0, 1.0)

var top_collision_polygon: CollisionPolygon2D
var mid_collision_polygon: CollisionPolygon2D
var bottom_collision_polygon: CollisionPolygon2D
var wall_polygon: WallPolygon
var type: WallPolygon.WallPolygonType
var segment_type: String = "unknown"

func _ready() -> void:
	initialize_wall()

func initialize_wall() -> void:
	top_collision_polygon = $TopCollisionPolygon
	mid_collision_polygon = $MidCollisionPolygon
	bottom_collision_polygon = $BottomCollisionPolygon
	wall_polygon = $WallPolygon
	wall_polygon.color = color

func get_type() -> WallPolygon.WallPolygonType:
	return type

func set_type(new_type: WallPolygon.WallPolygonType) -> void:
	type = new_type
	wall_polygon.set_type(new_type)
	sync_collision_polygon()

func get_polygon() -> WallPolygon:
	return wall_polygon

func set_polygon(new_polygon: WallPolygon) -> void:
	wall_polygon = new_polygon

func sync_collision_polygon() -> void:
	if wall_polygon == null:
		return
	if wall_polygon.top_section == null or wall_polygon.mid_section == null or wall_polygon.bottom_section == null:
		return

	var top_edge = wall_polygon.top_section.top_edge
	var mid_edge = wall_polygon.mid_section.top_edge
	var bottom_edge = wall_polygon.bottom_section.top_edge
	var bottom_floor = wall_polygon.bottom_section.bottom_edge
	if top_edge == null or mid_edge == null or bottom_edge == null or bottom_floor == null:
		return

	_update_collision_polygon(top_collision_polygon, top_edge, mid_edge)
	_update_collision_polygon(mid_collision_polygon, mid_edge, bottom_edge)
	_update_collision_polygon(bottom_collision_polygon, bottom_edge, bottom_floor)

func _update_collision_polygon(collision_polygon: CollisionPolygon2D, top_edge: SectionEdge, bottom_edge: SectionEdge) -> void:
	collision_polygon.polygon = PackedVector2Array([
		top_edge.left_coord,
		top_edge.right_coord,
		bottom_edge.right_coord,
		bottom_edge.left_coord,
	])
