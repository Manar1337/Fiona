class_name GravityActor

extends CharacterBody2D
@export var gravity:float

@onready var move_component: MoveComponent = $MoveComponent
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent

var speed = 0

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hurtbox_component.hurt.connect(was_hit)

func _physics_process(_delta):
	if !is_on_floor():
		velocity.y += gravity

	move_and_slide()

func was_hit(_obstacle:HitboxComponent):
	pass

func die():
	queue_free()
