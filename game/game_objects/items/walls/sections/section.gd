class_name Section

var top_edge: SectionEdge :
	get:
		return top_edge
	set(value):
		top_edge = value
		
	
var bottom_edge: SectionEdge :
	get:
		return bottom_edge
	set(value):
		bottom_edge = value

func _ready():
	top_edge = SectionEdge.new()
	bottom_edge = SectionEdge.new()

func get_edges():
	return [top_edge, bottom_edge]

func set_edges(top: SectionEdge, bottom: SectionEdge):
	top_edge = top
	bottom_edge = bottom

func print_edges(pre_string:String = "", indent = 0):
	top_edge.print_coords(pre_string + "[color=cyan]topedge - [/color]", indent)
	bottom_edge.print_coords(pre_string +  "[color=cyan]bottomedge - [/color]", indent)
