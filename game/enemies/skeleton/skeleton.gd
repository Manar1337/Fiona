extends CharacterBody2D

@onready var move_component = $MoveComponent
@onready var hurtbox_component = $HurtboxComponent as HurtboxComponent
@onready var hitbox_component = $HitboxComponent as HitboxComponent

enum states {WALKING, JUMPING, FALLING}
var speed = -64
var state = states.WALKING

func _ready():
	move_component.velocity.x = speed
	hurtbox_component.hurt.connect(was_hit.unbind(1))

func _physics_process(_delta):
	if is_on_floor():
		if state == states.FALLING: die()
		move_component.velocity.x = speed
	else:
		velocity.y += 5
		move_component.velocity.x = 0
		if velocity.y > 10: state = states.FALLING
	move_and_slide()	

func was_hit():
	state = states.JUMPING
	hurtbox_component.is_invincible = true
	hitbox_component.is_harmless = true
	velocity.y = -300
	
func die():
	queue_free()

