extends Node

@onready var player_flying: Player = $PlayerFlying
@onready var flight_timer: Timer = $FlightTimer

func _ready() -> void:
	player_flying.has_landed.connect(end_level)

func end_level():
	GameData.level = 1
