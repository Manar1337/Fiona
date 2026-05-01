class_name Skeleton

extends GravityActor

@onready var star_spawner: SpawnerComponent = $StarSpawner

enum states {WALKING, JUMPING, FALLING}

var state = states.WALKING

func _ready():
	super()
	add_to_group("enemies")

func _physics_process(_delta):
	super(_delta)
	if is_on_floor():
		if state == states.FALLING: die()
	else:
		if state == states.JUMPING and velocity.y > 10: state = states.FALLING

func was_hit(_obstacle:HitboxComponent):
	if _obstacle.is_player:
		if hurtbox_component.is_invincible: return
		die()

	if is_on_floor():
		hurtbox_component.is_invincible = true
		hitbox_component.is_harmless = true
		state = states.JUMPING
		move_physical_component.set_mode("jump")

func die():
	star_spawner.spawn(self.global_position, GameData.current_level_node)
	GameData.score += score
	queue_free()

func freeze():
	super.freeze()
	velocity.y = 0
