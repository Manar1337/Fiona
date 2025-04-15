class_name HighScoreTable
extends Control

@onready var input_name: LineEdit = $InputName

var current_score: int = 250000  # Set from outside when player finishes game.

func _ready():
	input_name.grab_focus()
	input_name.connect("text_submitted", _on_input_name_submitted)

func _on_input_name_submitted(submitted_name: String):
	var final_name = submitted_name.strip_edges()
	if final_name.is_empty():
		final_name = "Anonymous"

	add_high_score(final_name, current_score)
	print("High Scores: ", GameData.high_score_table)

	GameData.level_requested.emit("start")


func add_high_score(hs_name: String, score: int):
	print("Adding high score: ", hs_name, " with score: ", score)

	var entry = {
		"name": hs_name,
		"score": "%06d" % score  # C64 style
	}

	# Make a clean copy of current scores
	var scores = []
	for s in GameData.high_score_table:
		scores.append({
			"name": str(s["name"]),
			"score": str(s["score"])
		})

	scores.append(entry)
	print("Scores before sort: ", scores)

	# Sort using Godot 4.4 style: "should a come after b?"
	scores.sort_custom(Callable(self, "compare_scores"))

	print("Scores after sort: ", scores)

	scores.reverse()  # <- Important! Highest score first now

	print("Scores after reverse: ", scores)

	# Trim to 8 entries
	if scores.size() > 8:
		scores = scores.slice(0, 8)

	print("Scores after trim: ", scores)

	GameData.high_score_table = scores


# For descending order (highest score first)
func compare_scores(a, b):
	var sa = int(a["score"])
	var sb = int(b["score"])
	return sa < sb  # TRUE means a comes after b → descending
