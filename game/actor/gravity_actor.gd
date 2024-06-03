class_name GravityActor

extends CharacterBody2D

@onready var move_component: MoveComponent = $MoveComponent
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent

@export var gravity:float
@export var has_target:bool = false

var speed = 0
var target = null

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hurtbox_component.hurt.connect(was_hit)


func set_target(new_target):
	target = new_target

func _physics_process(_delta):
	if !is_on_floor():
		velocity.y += gravity

	move_and_slide()

func was_hit(_obstacle:HitboxComponent):
	pass

func die():
	queue_free()
