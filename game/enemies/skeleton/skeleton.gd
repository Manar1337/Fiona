extends Node2D

@onready var move_component = $MoveComponent
@onready var hurtbox_component = $HurtboxComponent as HurtboxComponent
@onready var hitbox_component = $HitboxComponent as HitboxComponent

var speed = -32 + (randf() * -32)
func _ready():
	move_component.velocity.x = speed
	hurtbox_component.hurt.connect(die)
	hitbox_component.hit_hurtbox.connect(die)

func _process(delta):
	pass

func die(hurtbox:Area2D):
	if hurtbox == hurtbox_component: return
	if hurtbox == hitbox_component: return
	
	queue_free()

