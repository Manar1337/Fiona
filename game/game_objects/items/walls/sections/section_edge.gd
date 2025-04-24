
class_name SectionEdge

var left_coord: Vector2
var right_coord: Vector2

func get_coords():
	return [left_coord, right_coord]

func set_coords(coords: Array):
	left_coord = coords[0]
	right_coord = coords[1]

func print_coords(pre_string:String = "",  indent = 0):
	var indent_str = ""
	for i in range(indent):
		indent_str += " "
	print_rich(indent_str,pre_string, "[color=green]left:",left_coord, "  right:",right_coord,"[/color]")



