class_name HighScoreTable
extends Control

@onready var input_name: LineEdit = $InputName

var current_score: int = 0 

func _ready():
	input_name.text = ".".repeat(input_name.MAX_LENGTH)
	input_name.grab_focus()
	input_name.text_submitted.connect(_on_input_name_submitted)

func _on_input_name_submitted(submitted_name: String):
	var final_name = submitted_name.strip_edges()
	if final_name.is_empty():
		final_name = "Anonymous"

	add_high_score(final_name, GameData.score)

	GameData.high_score_visible = false
	SignalHandler.restart_game.emit()
	# SignalHandler.level_requested.emit(LevelConstants.LevelType.START, 0)

func add_high_score(hs_name: String, score: int):

	var entry = {
		"name": hs_name,
		"score": "%06d" % score
	}
	var scores = []
	for s in GameData.high_score_table:
		scores.append({
			"name": str(s["name"]),
			"score": str(s["score"])
		})

	scores.append(entry)
	scores.sort_custom(Callable(self, "compare_scores"))
	scores.reverse()  # <- Important! Highest score first now
	if scores.size() > 8:
		scores = scores.slice(0, 8)

	GameData.high_score_table = scores

func compare_scores(a, b):
	var sa = int(a["score"])
	var sb = int(b["score"])
	return sa < sb  # TRUE means a comes after b → descending
