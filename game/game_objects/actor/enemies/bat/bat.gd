class_name bat

extends Actor

@export var entrance_time: float = 2.0
@export var entrance_speed: float = 32.0
@export var random_flight_time: float = 1.0
@export var random_flight_speed: float = 64.0

@onready var explosion_spawner: SpawnerComponent = $ExplosionSpawner

enum states {SPAWNING,FLYING, FALLING}

var state = states.SPAWNING

func _ready():
	super()
	add_to_group("enemies")
	hitbox_component.hit_hurtbox.connect(Callable(self, "explode"))
	set_state(states.SPAWNING)

func set_state(new_state):
	state = new_state
	match state:
		states.SPAWNING:
			move_component.set_mode("steady")
			make_entrance()
		states.FALLING:
			move_component.set_mode("fall")
		states.FLYING:
			move_component.set_mode("steady")
			fly_randomly()

func was_hit(_obstacle: HitboxComponent):
	die()

func make_entrance():
	var timer = get_tree().create_timer(entrance_time)
	while timer.time_left > 0:
		await get_tree().process_frame
		if is_frozen or state != states.SPAWNING:
			timer.time_left = 0
			return

	set_state(states.FLYING)

func fly_randomly():
	if is_frozen:
		return
	move_component.set_mode("steady")
	var random_speed = 64 + (randf() * 32)
	move_component.set_speed(random_speed)

	var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var new_position = global_transform.origin + random_direction * random_speed
	
	# Apply limits
	if new_position.y > 120:
		random_direction.y = -abs(random_direction.y)
	elif new_position.y < 0:
		random_direction.y = abs(random_direction.y)
	
	if new_position.x < 0:
		random_direction.x = abs(random_direction.x)
	elif new_position.x > 320:
		random_direction.x = -abs(random_direction.x)

	move_component.set_mode_data([random_direction])

	var timer = get_tree().create_timer(random_flight_time)
	while timer.time_left > 0:
		await get_tree().process_frame
		if is_frozen or state != states.FLYING:
			timer.time_left = 0
			return
	if state == states.FLYING:
		fly_randomly()


func die(_unused: Variant = null):
	if hurtbox_component.is_invincible:
		return
	hurtbox_component.is_invincible = true
	set_state(states.FALLING)
	GameData.score += score

func explode(_unused: Variant = null):
	call_deferred("spawn_explosion")

func spawn_explosion():
	explosion_spawner.spawn(global_transform.origin, GameData.current_level_node)
	queue_free()
