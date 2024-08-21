class_name MagicExplosion

extends AnimatedSprite2D

@onready var death_timer: Timer = $DeathTimer
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D
@onready var move_component: MoveComponent = $MoveComponent

func _ready() -> void:
	death_timer.timeout.connect(die)
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)

func set_speed(speed):
	move_component.set_speed(speed)

func set_direction(direction):
	move_component.set_mode_data([direction])


func die():
	queue_free()
