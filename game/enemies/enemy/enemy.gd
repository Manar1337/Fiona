class_name Enemy

extends Node

@onready var move_component: MoveComponent = $MoveComponent
@onready var hurtbox_component = $HurtboxComponent as HurtboxComponent
@onready var hitbox_component = $HitboxComponent as HitboxComponent
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D


enum directions {UP, DOWN, LEFT, RIGHT}

var speed = 0

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hurtbox_component.hurt.connect(was_hit)

func was_hit(_obstacle:HitboxComponent):
	pass

func die():
	queue_free()
