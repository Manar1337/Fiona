extends Node
@onready var score_value = $ScoreValue
@onready var spell_value = $SpellValue
@onready var lev_value = $LevValue
@onready var lives_value = $LivesValue


# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.connect("score_changed", _on_score_changed)
	GameData.connect("health_changed", _on_health_changed)
	GameData.connect("lives_changed", _on_lives_changed)
	GameData.connect("level_changed", _on_level_changed)

	# Initialize labels with current values
	_on_score_changed(GameData.score)
	_on_health_changed(GameData.health)

func _on_score_changed(new_score):
	score_value.text = str(new_score).pad_zeros(6)

func _on_health_changed(new_health):
	spell_value.text = str(new_health).pad_zeros(6)
	
func _on_level_changed(new_level):
	lev_value.text = str(new_level).pad_zeros(2)
	
func _on_lives_changed(new_lives):
	lives_value.text = str(new_lives)
