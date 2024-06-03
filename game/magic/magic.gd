class_name Magic

extends Area2D

@onready var death_timer: Timer = $DeathTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	death_timer.timeout.connect(die)

func _on_area_entered(area: Area2D):
	print("magic found")

func die():
	queue_free()
