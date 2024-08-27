extends Node

@onready var score_value: Label = $ScoreValue
@onready var spell_value: Label = $SpellValue
@onready var lev_value: Label = $LevValue
@onready var lives_value: Label = $LivesValue
@onready var death_message: Control = $DeathMessage

func _ready():
	GameData.connect("score_changed", _on_score_changed)
	GameData.connect("health_changed", _on_health_changed)
	GameData.connect("lives_changed", _on_lives_changed)
	GameData.connect("level_changed", _on_level_changed)
	GameData.connect("show_death_message", _on_show_death_message)
	GameData.connect("show_gui", _on_show_gui)

	_on_score_changed(GameData.score)
	_on_health_changed(GameData.health)
	_on_lives_changed(GameData.lives)

func _on_score_changed(new_score):
	score_value.text = str(new_score).pad_zeros(6)

func _on_health_changed(new_health):
	spell_value.text = str(new_health).pad_zeros(6)

func _on_level_changed(new_level):
	lev_value.text = str(new_level).pad_zeros(2)

func _on_lives_changed(new_lives):
	lives_value.text = str(new_lives)

func _on_show_death_message(show_message):
	death_message.visible = show_message

func _on_show_gui(will_show):
	for child in get_children():
		if child is Label:
			child.visible = will_show
	death_message.visible = will_show
