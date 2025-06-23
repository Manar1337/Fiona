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
		print("Skeleton is not on the floor, current state: ", state)
		# move_component.set_speed(0)
		# move_physical_component.set_speed(0)
		print("velocity: ", velocity)
		if state == states.JUMPING and velocity.y > 10: state = states.FALLING


func was_hit(_obstacle:HitboxComponent):
	print("Skeleton was hit by: ", _obstacle.name)
	if is_on_floor():
		print("Skeleton is on the floor, jumping!")
		hurtbox_component.is_invincible = true
		hitbox_component.is_harmless = true
		state = states.JUMPING
		# move_component.set_speed(0)
		move_physical_component.set_speed(300)
		move_physical_component.set_mode_data([Vector2.UP])

func die():
	star_spawner.spawn(self.global_position, GameData.current_level_node)
	GameData.score += score
	queue_free()

func freeze():
	super.freeze()
	velocity.y = 0
