class_name bat

extends Actor

@export var entrance_time: float = 2.0
@export var entrance_speed: float = 32.0
@export var random_flight_time: float = 1.0
@export var random_flight_speed: float = 64.0
@export var fall_spawns_pickup_magic: bool = false
@export var landing_y: float = 184.0
@export var magic_spawn_y_offset: float = -6.0
@export var can_target_player: bool = false
@export var explode_on_touch: bool = true
@export var touch_spawns_pickup_magic: bool = false
@export var target_follow_speed: float = 100.0
@export var target_max_duration: float = 10.0
@export var target_cooldown: float = 10.0
@export var target_trigger_x_range: float = 16.0
@export var target_y_change_interval_min: float = 0.5
@export var target_y_change_interval_max: float = 1.5
@export var target_descend_speed_factor: float = 0.5

@onready var explosion_spawner: SpawnerComponent = $ExplosionSpawner

enum states {SPAWNING,FLYING, TARGETING, FALLING}

const MAGIC_SCENE: PackedScene = preload("res://game/game_objects/items/magic/magic.tscn")

var state = states.SPAWNING
var _fall_resolved: bool = false
var _target_time_remaining: float = 0.0
var _target_cooldown_remaining: float = 0.0
var _target_y_change_remaining: float = 0.0
var _touch_resolved: bool = false

func _ready():
	super()
	add_to_group("enemies")
	hitbox_component.hit_hurtbox.connect(_on_hit_hurtbox)
	set_state(states.SPAWNING)

func _process(delta: float) -> void:
	if is_frozen:
		return

	if _target_cooldown_remaining > 0.0:
		_target_cooldown_remaining = max(_target_cooldown_remaining - delta, 0.0)

	if state == states.FALLING and fall_spawns_pickup_magic and not _fall_resolved and global_position.y >= landing_y:
		_resolve_fall_landing()
	elif state == states.FLYING and _can_begin_targeting():
		set_state(states.TARGETING)
	elif state == states.TARGETING:
		_update_targeting(delta)

func set_state(new_state):
	state = new_state
	match state:
		states.SPAWNING:
			_fall_resolved = false
			move_component.set_mode("steady")
			make_entrance()
		states.FALLING:
			_fall_resolved = false
			move_component.set_mode("fall")
		states.FLYING:
			_fall_resolved = false
			move_component.set_mode("steady")
			fly_randomly()
		states.TARGETING:
			_fall_resolved = false
			_start_targeting()

func was_hit(_obstacle: HitboxComponent):
	if _touch_resolved:
		return
	if _obstacle != null and _obstacle.is_player:
		_handle_player_touch()
		return
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
	if state != states.FLYING:
		return
	move_component.set_mode("steady")
	var random_speed = random_flight_speed + (randf() * 32)
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

func _start_targeting() -> void:
	move_component.set_mode("steady")
	_target_time_remaining = randf_range(1.0, target_max_duration)
	_pick_targeting_direction()

func _update_targeting(delta: float) -> void:
	if not is_instance_valid(target):
		_end_targeting()
		return

	_target_time_remaining -= delta
	_target_y_change_remaining -= delta

	if _target_y_change_remaining <= 0.0:
		_pick_targeting_direction()

	global_position.x = move_toward(global_position.x, target.global_position.x, target_follow_speed * delta)

	if _target_time_remaining <= 0.0:
		_end_targeting()

func _pick_targeting_direction() -> void:
	if randf() < 0.5:
		move_component.set_speed(0.0)
		move_component.set_mode_data([Vector2.ZERO])
	else:
		move_component.set_speed(target_follow_speed * target_descend_speed_factor)
		move_component.set_mode_data([Vector2.DOWN])
	_target_y_change_remaining = randf_range(target_y_change_interval_min, target_y_change_interval_max)

func _end_targeting() -> void:
	_target_cooldown_remaining = target_cooldown
	set_state(states.FLYING)

func _can_begin_targeting() -> bool:
	if not can_target_player:
		return false
	if _target_cooldown_remaining > 0.0:
		return false
	if not is_instance_valid(target):
		return false
	if global_position.y >= target.global_position.y:
		return false
	return abs(global_position.x - target.global_position.x) <= target_trigger_x_range


func die(_unused: Variant = null):
	if hurtbox_component.is_invincible or _touch_resolved:
		return
	hurtbox_component.is_invincible = true
	hitbox_component.is_harmless = true
	_touch_resolved = true
	set_state(states.FALLING)
	GameData.score += score

func explode(_unused: Variant = null):
	if _touch_resolved:
		return
	_touch_resolved = true
	hurtbox_component.is_invincible = true
	hitbox_component.is_harmless = true
	call_deferred("spawn_explosion")

func _on_hit_hurtbox(_hurtbox: HurtboxComponent) -> void:
	if _touch_resolved:
		return
	if touch_spawns_pickup_magic:
		_handle_player_touch()
		return
	if not explode_on_touch:
		return
	explode()

func _handle_player_touch() -> void:
	if _touch_resolved:
		return
	_touch_resolved = true
	hurtbox_component.is_invincible = true
	hitbox_component.is_harmless = true
	if touch_spawns_pickup_magic:
		_spawn_pickup_magic(global_position + Vector2(0, magic_spawn_y_offset))
	queue_free()

func spawn_explosion():
	explosion_spawner.spawn(global_transform.origin, GameData.current_level_node)
	queue_free()

func _resolve_fall_landing() -> void:
	_fall_resolved = true
	global_position.y = landing_y
	_spawn_pickup_magic(global_position + Vector2(0, magic_spawn_y_offset))
	queue_free()

func _spawn_pickup_magic(spawn_position: Vector2) -> void:
	var magic: Node2D = MAGIC_SCENE.instantiate()
	GameData.current_level_node.add_child(magic)
	magic.global_position = spawn_position
