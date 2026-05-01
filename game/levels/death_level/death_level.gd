extends Node2D

# This is the death level script, which handles the player's death and respawn logic.
# It is a mockup for now, as the death level is not fully implemented.
# The player will try to nagigate though a tunnel, and if they fail, they will lose a life.
# If they have no lives left, the game will end.
# If they succeed, they will be sent back to the last level with their lives intact.
# This script is a placeholder and will be replaced with the real death level logic later.

@onready var player_blasting: CharacterBody2D = $PlayerBlasting
@onready var tunnel: Node2D = $Tunnel
func _ready():
	SignalHandler.game_over.connect(_on_game_over)

func _input(_event):
	# Since the deathlevel is far from finished we will replace the function with this mockup
	# All it does is simulate the player pressing the fire button to lose a life.
	# In the future, this will be replaced with actual player input handling.
	# For now, we will just print a message to the console.
	# We will replace it with the real function later

	if Input.is_action_just_pressed("fire"):
		GameData.lives -= 1
		if GameData.lives <= 0:
			GameData.lives = 0
			SignalHandler.game_over.emit()
		else:
			SignalHandler.level_requested.emit(GameData.previous_level_type, GameData.level)

func _on_game_over():
	SignalHandler.show_game_over_message.emit(true)
	await get_tree().create_timer(2.0).timeout
	SignalHandler.show_game_over_message.emit(false)

	SignalHandler.level_requested.emit(LevelConstants.LevelType.HIGH_SCORE, 0)
