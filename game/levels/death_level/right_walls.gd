class_name RightWalls
extends Node2D

@onready var wall1: Wall = $RightWall1
@onready var wall2: Wall = $RightWall2
@onready var wall3: Wall = $RightWall3

const NR_OF_WALLS = 3

var walls = []

var top_wall = 0
var mid_wall = 1
var bottom_wall = 2

var top_pos = -133
var mid_pos = 0
var bottom_pos = 133

func _ready() -> void:
	wall1.set_type(WallPolygon.WallPolygonType.RIGHT)
	wall2.set_type(WallPolygon.WallPolygonType.RIGHT)
	wall3.set_type(WallPolygon.WallPolygonType.RIGHT)

	walls.append(wall1)
	walls.append(wall2)
	walls.append(wall3)

static func fit_walls(upper_wall: Wall, lower_wall: Wall) -> void:
	var upper_polygon = upper_wall.get_polygon()
	var lower_top_section = lower_wall.get_polygon().top_section
	var upper_edge: SectionEdge = lower_top_section.top_edge
	var lower_edge: SectionEdge = lower_top_section.bottom_edge
	
	update_mid_section_bottom(upper_polygon, upper_edge)
	update_bottom_section(upper_polygon, upper_edge, lower_edge)
	
	upper_polygon.update_polygon()

static func update_mid_section_bottom(polygon: WallPolygon, edge: SectionEdge) -> void:
	polygon.mid_section.bottom_edge.left_coord.x = edge.left_coord.x
	polygon.mid_section.bottom_edge.right_coord.x = edge.right_coord.x

static func update_bottom_section(polygon: WallPolygon, upper_edge: SectionEdge, lower_edge: SectionEdge) -> void:
	polygon.bottom_section.top_edge.left_coord.x = upper_edge.left_coord.x
	polygon.bottom_section.top_edge.right_coord.x = upper_edge.right_coord.x
	
	polygon.bottom_section.bottom_edge.left_coord.x = lower_edge.left_coord.x
	polygon.bottom_section.bottom_edge.right_coord.x = lower_edge.right_coord.x

func flip_walls(wall_component:WallComponent):
	const TOP_INDEX = 0
	const MID_INDEX = 1
	const BOTTOM_INDEX = 2

	var positions = [top_pos, mid_pos, bottom_pos]
	var double_walls = walls + walls
	
	var rotated_walls = double_walls.slice(2 - top_wall,5 - top_wall)
	rotated_walls[BOTTOM_INDEX] = change_wall(rotated_walls[BOTTOM_INDEX], wall_component)
   
	rotated_walls[BOTTOM_INDEX].position.y = positions[TOP_INDEX]
	rotated_walls[TOP_INDEX].position.y = positions[MID_INDEX]
	rotated_walls[MID_INDEX].position.y = positions[BOTTOM_INDEX]
	
	fit_walls(rotated_walls[BOTTOM_INDEX], rotated_walls[TOP_INDEX])
	
	top_wall = (top_wall + 1) % NR_OF_WALLS
	mid_wall = (mid_wall + 1) % NR_OF_WALLS
	bottom_wall = (bottom_wall + 1) % NR_OF_WALLS
			
func change_wall(wall:Wall, wall_type:WallComponent) -> Wall:
	return wall_type.change_right_wall(wall)

func print_walls():
	var text_walls = [
		{"name": "Wall 1", "color": "red", "wall": wall1},
		{"name": "Wall 2", "color": "green", "wall": wall2},
		{"name": "Wall 3", "color": "blue", "wall": wall3}
	]
	text_walls.sort_custom(sort_by_y_position)

	for wall_info in text_walls:
		print_rich("[color=%s]%s[/color]" % [wall_info.color, wall_info.name])
		wall_info.wall.wall_polygon.print_sections(4)
		print()

func sort_by_y_position(a, b):
	return a.wall.position.y < b.wall.position.y
