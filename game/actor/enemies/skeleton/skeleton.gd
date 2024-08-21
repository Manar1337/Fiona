class_name Skeleton

extends GravityActor

@onready var star_spawner: SpawnerComponent = $StarSpawner

enum states {WALKING, JUMPING, FALLING}

var state = states.WALKING

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

func die():
	star_spawner.spawn(self.global_position)
	GameData.score += score
	queue_free()
