extends Node2D

# This is the death level script, which handles the player's death and respawn logic.
# It is a mockup for now, as the death level is not fully implemented.
# The player will try to nagigate though a tunnel, and if they fail, they will lose a life.
# If they have no lives left, the game will end.
# If they succeed, they will be sent back to the last level with their lives intact.
# This script is a placeholder and will be replaced with the real death level logic later.

@onready var player_blasting: PlayerBlasting = $PlayerBlasting
@onready var tunnel: Tunnel = $Tunnel

var death_in_progress: bool = false

func _ready():
	SignalHandler.escaped_tunnel.connect(_on_escaped_tunnel)

func handle_player_death(global_position: Vector2) -> void:
	if death_in_progress:
		return

	death_in_progress = true
	tunnel.stop_moving()
	await player_blasting.start_death_sequence(global_position)
	await get_tree().create_timer(1.0).timeout
	GameData.lives -= 1

	if GameData.lives <= 0:
		await _run_game_over_flow()
		return

	SignalHandler.level_requested.emit(GameData.previous_level_type, GameData.level)

func _run_game_over_flow() -> void:
	SignalHandler.show_game_over_message.emit(true)
	await get_tree().create_timer(5.0).timeout
	SignalHandler.show_game_over_message.emit(false)

	if TestSettings.is_available() and TestSettings.disable_high_score:
		SignalHandler.level_requested.emit(LevelConstants.LevelType.START, 0)
		return
	if GameData.qualifies_for_high_score(GameData.score):
		SignalHandler.level_requested.emit(LevelConstants.LevelType.HIGH_SCORE, 0)
	else:
		SignalHandler.level_requested.emit(LevelConstants.LevelType.START, 0)

func _on_escaped_tunnel() -> void:
	await player_blasting.start_escape_flyout()
	SignalHandler.show_escape_message.emit(true)
	await get_tree().create_timer(1.5).timeout
	SignalHandler.show_escape_message.emit(false)
	SignalHandler.level_requested.emit(LevelConstants.LevelType.DEATH, GameData.level)
