class_name HighScoreLevel

extends Node

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var high_score_table: HighScoreTable = $HighScoreTable

func _ready():
	SignalHandler.show_high_score.connect(_on_show_high_score)
	set_random_position()

func set_position(new_position: float):
	tile_map_layer.transform.origin.x = -new_position

func set_random_position():
	var random_pos = randf_range(0, (get_background_width() * 8) - 320)
	set_position(random_pos)

func get_background_width():
	return tile_map_layer.get_used_rect().size.x

func _on_show_high_score(onoff):
	high_score_table.visible = onoff
	high_score_table.show()
