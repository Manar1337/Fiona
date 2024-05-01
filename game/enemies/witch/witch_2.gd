class_name Witch2

extends ShootingEnemy1

@onready var dress = $Dress
@onready var color_flicker_component = $ColorFlickerComponent

enum states {FLYING, CHASING, FALLING}

var state = states.FLYING

var target_window = 8
var sight = randf() * 300

func _ready():
	speed = -64 + (randf() * -32)
	dress.self_modulate = Color( sight / 300, 0, 1 - ( sight / 300 ))
	super()

func _process(_delta):
	if state == states.FALLING:
		fall()
	if target != null && is_instance_valid(target):
		if state == states.CHASING:
			chase()
		if self.global_transform.origin.distance_to(target.global_transform.origin) < sight:
			if self.global_transform.origin.x > target.global_transform.origin.x + sight/3:
				if !fire_lock:
					shoot()
		if state == states.FLYING && self.global_transform.origin.distance_to(target.global_transform.origin) < sight:
			state = states.CHASING

func was_hit(_obstacle:HitboxComponent):
	die()

func chase():
	if target.global_position.y < self.global_position.y - target_window:
		move_component.velocity.y = speed
	elif target.global_position.y > self.global_position.y + target_window:
		move_component.velocity.y = -speed
	else: move_component.velocity.y = 0

func fall():
	move_component.velocity.x = 0
	move_component.velocity.y+=15

	fire_lock = true

func die():
	hurtbox_component.is_invincible = true
	color_flicker_component.enabled = true
	state = states.FALLING
	GameData.set_score(GameData.score + 100)
