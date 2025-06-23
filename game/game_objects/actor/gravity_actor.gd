class_name GravityActor

extends CharacterBody2D

@onready var move_component: MoveComponent = $MoveComponent
@onready var move_physical_component: MovePhysicalComponent = $MovePhysicalComponent
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent

@export var score:int = 0
@export var has_target:bool = false
@export var hovering: bool = false

var target = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	move_physical_component.set_is_hovering(hovering)
	move_physical_component.set_gravity(gravity)
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hurtbox_component.hurt.connect(was_hit)
	SignalHandler.connect("freeze_everything", _on_freeze_everything)

func _physics_process(_delta):
	if GameData.everything_frozen:
		return
	

func set_target(new_target):
	target = new_target

func was_hit(_obstacle:HitboxComponent):
	pass

func die():
	queue_free()

func _on_freeze_everything(is_frozen:bool) -> void:
	if is_frozen:
		freeze()
	else:
		unfreeze()

func freeze():
	move_component.stop()
	move_physical_component.stop()
	hitbox_component.set_enabled(false)
	hurtbox_component.is_invincible = true
	
func unfreeze():
	move_component.start()
	move_physical_component.start()
	hitbox_component.set_enabled(true)
	hurtbox_component.is_invincible = false
	velocity = Vector2.ZERO
	if is_on_floor():
		velocity.y = 0

