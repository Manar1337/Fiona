class_name Skeleton

extends GravityActor

enum states {WALKING, JUMPING, FALLING}

var state = states.WALKING

func _ready():
	super()
	move_component.set_mode("steady")

func _physics_process(_delta):
	super(_delta)
	if is_on_floor():
		if state == states.FALLING: die()
	else:
		velocity.x += 0
		move_component.set_speed(0)
		if velocity.y > 10: state = states.FALLING


func was_hit(_obstacle:HitboxComponent):
	hurtbox_component.is_invincible = true
	hitbox_component.is_harmless = true
	velocity.y = -300
