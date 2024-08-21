class_name Actor
extends Node2D

@onready var move_component: MoveComponent = $MoveComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D

@export var score: int = 0
@export var has_target: bool = false

var target: Node = null

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(die.unbind(1))
	hurtbox_component.hurt.connect(was_hit)

func was_hit(_obstacle:HitboxComponent):
	pass

func set_target(new_target: Node):
	if is_instance_valid(new_target):
		target = new_target
	else:
		target = null

func die():
	# Perform any necessary cleanup before freeing
	queue_free()
