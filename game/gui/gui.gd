extends Control

@onready var score_value: Label = $ScoreValue
@onready var spell_value: Label = $SpellValue
@onready var lev_value: Label = $LevValue
@onready var lives_value: Label = $LivesValue
@onready var escape_value: Label = $EscapeValue
@onready var death_message: Control = $DeathMessage
@onready var game_over_message: Control = $GameOverMessage
@onready var escape_message: Control = $EscapeMessage

func _ready():
	SignalHandler.score_changed.connect(_on_score_changed)
	SignalHandler.spellpower_changed.connect(_on_spellpower_changed)
	SignalHandler.lives_changed.connect(_on_lives_changed)
	SignalHandler.level_changed.connect(_on_level_changed)
	SignalHandler.death_tunnel_progress_changed.connect(_on_death_tunnel_progress_changed)
	SignalHandler.show_death_message.connect(_on_show_death_message)
	SignalHandler.show_game_over_message.connect(_on_show_game_over_message)
	SignalHandler.show_escape_message.connect(_on_show_escape_message)
	SignalHandler.show_gui.connect(_on_show_gui)

	_on_score_changed(GameData.score)
	_on_spellpower_changed(GameData.spellpower)
	_on_lives_changed(GameData.lives)
	_update_escape_visibility(false)

func _input(event):
	if TestSettings.is_available() and TestSettings.disable_high_score:
		return
	if event.is_action_pressed("show_highscore") and GameData.high_score_visible == false:
		SignalHandler.level_requested.emit(LevelConstants.LevelType.HIGH_SCORE, 0)
		accept_event()  # Prevent the event from propagating further

func _on_score_changed(new_score):
	score_value.text = str(new_score).pad_zeros(6)

func _on_spellpower_changed(new_spellpower):
	spell_value.text = str(new_spellpower).pad_zeros(6)

func _on_level_changed(new_level):
	lev_value.text = str(new_level).pad_zeros(2)
	_update_escape_visibility(true)

func _on_lives_changed(new_lives):
	lives_value.text = str(new_lives)

func _on_death_tunnel_progress_changed(distance_left: int, _distance_total: int, _tunnel_speed: float):
	var display_distance_left = int(ceil(max(distance_left, 0) / 10.0))
	escape_value.text = str(display_distance_left).pad_zeros(3)

func _on_show_death_message(show_message):
	death_message.visible = show_message

func _on_show_game_over_message(show_message):
	game_over_message.visible = show_message

func _on_show_escape_message(show_message):
	escape_message.visible = show_message

func _on_show_gui(will_show):
	for child in get_children():
		if child is Label:
			child.visible = will_show
	_update_escape_visibility(will_show)

func _update_escape_visibility(will_show: bool) -> void:
	var show_escape = will_show and GameData.current_level_type == LevelConstants.LevelType.DEATH
	$Escape.visible = show_escape
	escape_value.visible = show_escape
