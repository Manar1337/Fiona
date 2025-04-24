class_name WallPolygon

extends Polygon2D

enum WallPolygonType {
	LEFT,
	RIGHT
}

var indices = []
var wall_collide: CollisionPolygon2D
var wall_shape: Polygon2D
var top_section: Section
var mid_section: Section
var bottom_section: Section

var sections = [top_section, mid_section, bottom_section]

func _init() -> void:
	top_section = Section.new()
	mid_section = Section.new()
	bottom_section = Section.new()

func set_type(new_type: WallPolygonType):
	init_polygon(new_type)
	update_sections()
	
func get_top_section():
	return top_section

func get_mid_section():
	return mid_section

func get_bottom_section():
	return bottom_section

func get_sections():
	return [top_section, mid_section, bottom_section]

func init_polygon(type: WallPolygonType):
	match type:
		WallPolygonType.LEFT:
			init_left_polygon()
		WallPolygonType.RIGHT:
			init_right_polygon()

func set_top_section(section: Section):
	top_section = section
	update_sections()
	update_polygon()

func set_mid_section(section: Section):
	mid_section = section
	update_sections()
	update_polygon()

func set_bottom_section(section: Section):
	bottom_section = section
	update_sections()
	update_polygon()

func update_sections():
	top_section.set_edges(make_edge(polygon[0], polygon[1]), make_edge(polygon[7], polygon[2]))
	mid_section.set_edges(make_edge(polygon[7], polygon[2]), make_edge(polygon[6], polygon[3]))
	bottom_section.set_edges(make_edge(polygon[6], polygon[3]), make_edge(polygon[5], polygon[4]))

func update_polygon():
	polygon[0] = top_section.top_edge.left_coord
	polygon[1] = top_section.top_edge.right_coord
	polygon[2] = mid_section.top_edge.right_coord
	polygon[3] = bottom_section.top_edge.right_coord
	polygon[4] = bottom_section.bottom_edge.right_coord
	polygon[5] = bottom_section.bottom_edge.left_coord
	polygon[6] = bottom_section.top_edge.left_coord
	polygon[7] = mid_section.top_edge.left_coord


func init_left_polygon():
	polygon = [
		Vector2(0, 0), 
		Vector2(100, 0),
		Vector2(100, 66), 
		Vector2(100, 132), 
		Vector2(100, 198), 
		Vector2(0, 198), 
		Vector2(0, 132), 
		Vector2(0, 66), 
		]

func init_right_polygon():
	polygon = [
		Vector2(0, 0), 
		Vector2(-100, 0),
		Vector2(-100, 66), 
		Vector2(-100, 132), 
		Vector2(-100, 198), 
		Vector2(0, 198), 
		Vector2(0, 132), 
		Vector2(0, 66), 
		]

func make_edge(left: Vector2, right: Vector2) -> SectionEdge:
	var new_edge = SectionEdge.new()
	new_edge.left_coord = left
	new_edge.right_coord = right
	return new_edge

func print_sections(indent = 0):
	var indent_str = ""
	for i in range(indent):
		indent_str += " "
	print_rich(indent_str, "[color=orange]topsection:[/color]")
	top_section.print_edges("" , indent + 4)
	print_rich(indent_str, "[color=orange]midsection:[/color]")
	mid_section.print_edges("", indent + 4)
	print_rich(indent_str, "[color=orange]bottomsection:[/color]")
	bottom_section.print_edges("", indent + 4)
