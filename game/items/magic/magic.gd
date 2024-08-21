class_name Magic

extends Area2D

@onready var death_timer: Timer = $DeathTimer

enum states {FREE, STUCK, FALLING}

var target = null
var state = states.FREE
var cauldronarea = null
var carrier = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = states.FREE
	area_entered.connect(_on_area_entered)
	death_timer.timeout.connect(die)

func _process(_delta):
	match state:
		states.STUCK:
			if target:
				global_position = target.global_position
		states.FALLING:
			global_position.y += 0.3
			if global_position.y > 176:
				cauldronarea.splash()
				die()

func _on_area_entered(area: Area2D):
	match state:
		states.FREE:
			if area.name != "Cauldron":
				death_timer.start()
				if !area.get_parent().has_method("set_carries_magic"):
					return
				carrier = area.get_parent()
				if carrier.carries_magic:
					return
				set_target(carrier)
				carrier.carries_magic = true
				state = states.STUCK
				return
		states.STUCK:
			if area.name == "Cauldron":
				remove_carrier()
				state = states.FALLING
				death_timer.paused = true
				cauldronarea = area
func remove_carrier():
	if carrier:
		carrier.carries_magic = false
		carrier = null;

func die():
	remove_carrier()
	queue_free()

func set_target(new_target):
	target = new_target
