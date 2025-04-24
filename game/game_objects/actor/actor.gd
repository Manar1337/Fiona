class_name Actor
extends GameObject

@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent

@export var score: int = 0
@export var has_target: bool = false

var target: Node = null

func _ready():
	super._ready()
	hurtbox_component.hurt.connect(was_hit)

func was_hit(_obstacle: HitboxComponent):
	pass

func set_target(new_target: Node):
	if is_instance_valid(new_target):
		target = new_target
	else:
		target = null

func die():
	queue_free()

