extends Node

signal pause_game(onoff: bool)
signal score_changed(new_score: int)
signal spellpower_changed(new_spellpower: int)
signal lives_changed(new_lives: int)
signal level_changed(new_level: int)
signal level_requested(level_type: LevelConstants.LevelType, level: int)
signal next_level_requested()
signal freeze_everything(onoff: bool)
signal should_fly_up()
signal fly_up_finished()
signal show_death_message(show_message: bool)
signal show_game_over_message(show_message: bool)
signal show_high_score(onoff: bool)
signal show_gui(will_show_gui: bool)
signal player_sent_to_hell(current_level: int)
signal game_over()
signal restart_game()
signal level_completed()

func _ready() -> void:
	player_sent_to_hell.connect(_on_player_sent_to_hell)


# --- Sprite Control ---

func freezeEverything(on: bool) -> void:
	print("SignalHandler.freezeEverything: ", on)
	GameData.everything_frozen = on
	freeze_everything.emit(on)

func everyoneShouldFlyUp() -> void:
	GameData.has_fly_up_completed = false
	should_fly_up.emit()

func flyUpFinished() -> void:
	GameData.has_fly_up_completed = true
	fly_up_finished.emit()

# --- Pause Control ---

func pauseGame(on: bool) -> void:
	GameData.is_paused = on
	get_tree().paused = on
	pause_game.emit(on)

func _on_player_sent_to_hell() -> void:
	SignalHandler.show_death_message.emit(false)
	level_requested.emit(LevelConstants.LevelType.DEATH, GameData.level)
