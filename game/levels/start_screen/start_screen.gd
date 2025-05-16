class_name StartScreen

extends Node

@onready var switching_label = $SwitchingLabel
@export var start_level: int = 1

var top_text_first_part = ["FIONA RIDES OUT' BY IAM GRAY",
							"G MINOR FANTASIA ARRANGED BY CHRIS COX", 
							"HI-RES TITLE PICTURE BY CHRIS HAINES",
							"POEM FROM 'RUDDIGORE' BY W.S. GILBERT",
							"",
							"'FIONA RIDES OUT' BY IAM GRAY",
							"",
							"HERE FOLLOWS THE HIGHSCORE COVEN",
							"",
							]
var top_text_second_part = ["",
							"THANKS TO FIONA FOR MUCH INSPIRATION",
							"",
							"RIDE WELL! MAY BLACK DEMONS GUARD YOU!",
							"",
							"'FIONA RIDES OUT' BY IAM GRAY",
							]
var top_text = ""



var high_scores = []
var formated_scores = []
func _ready():
	high_scores = GameData.high_score_table
	formated_scores = format_high_scores(high_scores)
	top_text = top_text_first_part + formated_scores + top_text_second_part
	
	switching_label.set_lines(top_text)

func _input(_event):
	if Input.is_action_just_pressed("fire"):
		GameData.level_name = LevelConstants.LevelName.LEVEL_1

func format_high_scores(scores: Array) -> Array:
	var formatted = []
	for entry in scores:
		var score = int(entry["score"])  # Always convert to int
		formatted.append("%s : %s %06d" % [entry["name"].to_upper(), "SCORE", score])
	return formatted

func set_start_level(level: int):
	start_level = level
