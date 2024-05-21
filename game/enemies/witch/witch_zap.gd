class_name WitchZap

extends Node2D
@onready var visible_on_screen_enabler_2d = $VisibleOnScreenEnabler2D as VisibleOnScreenEnabler2D
@onready var hitbox_component = $HitboxComponent as HitboxComponent
@onready var move_component = $MoveComponent

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(queue_free.unbind(1))
	move_component.set_mode("steady")

func set_speed(speed):
	move_component.set_speed(speed)

func set_direction(direction):
	move_component.set_mode_data([direction])

