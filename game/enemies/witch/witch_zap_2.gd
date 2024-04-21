class_name WitchZap2

extends Node2D
@onready var visible_on_screen_enabler_2d = $VisibleOnScreenEnabler2D as VisibleOnScreenEnabler2D
@onready var hitbox_component = $HitboxComponent as HitboxComponent
@onready var move_component_2 = $MoveComponent2

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(queue_free.unbind(1))
	move_component_2.set_mode("steady")

func set_speed(speed):
	move_component_2.set_speed(speed)

func set_direction(direction):
	move_component_2.set_mode_data("steady", [direction])

