extends Node2D

@onready var move_component_1 = $MoveComponent1
@onready var visible_on_screen_enabler_2d = $VisibleOnScreenEnabler2D
@onready var hitbox_component = $HitboxComponent

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(queue_free.unbind(1))

func set_speed(speed):
	move_component_1.set_velocity(speed)
