extends Node2D

@onready var death_timer: Timer = $DeathTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	death_timer.timeout.connect(die)

func die():
	queue_free()
