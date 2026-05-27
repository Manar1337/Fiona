class_name BloodBomb
extends Bullet

@export var peak_y: float = 100.0
@export var gravity_scale: float = 1.0
@export var magic_spawn_y_offset: float = -6.0

@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var explosion_spawner: SpawnerComponent = $ExplosionSpawner

var floor_y: float = 184.0
var velocity: Vector2 = Vector2.ZERO
var _has_died: bool = false

func _ready():
	super()
	hurtbox_component.hurt.connect(_on_hurt)
	move_component.stop()
	_apply_launch_velocity()

func _physics_process(delta: float) -> void:
	if is_frozen or _has_died:
		return

	velocity.y += _get_gravity_per_second() * delta
	global_position += velocity * delta

	if global_position.y >= floor_y:
		global_position.y = floor_y
		_spawn_magic()

func launch(ground_y: float) -> void:
	floor_y = ground_y
	_apply_launch_velocity()

func on_hit():
	pass

func _on_hurt(hitbox: HitboxComponent) -> void:
	if hitbox.is_player:
		_spawn_magic()

func freeze() -> void:
	super.freeze()
	hurtbox_component.set_enabled(false)

func unfreeze() -> void:
	super.unfreeze()
	hurtbox_component.set_enabled(true)

func _apply_launch_velocity() -> void:
	var launch_distance: float = global_position.y - peak_y
	if launch_distance < 0.0:
		launch_distance = 0.0
	var gravity: float = _get_gravity_per_second()
	velocity = Vector2.ZERO
	if launch_distance > 0.0 and gravity > 0.0:
		velocity.y = -sqrt(2.0 * gravity * launch_distance)

func _get_gravity_per_second() -> float:
	var tick_gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity")) / 10.0
	return tick_gravity * Engine.physics_ticks_per_second * gravity_scale

func _spawn_magic() -> void:
	if _has_died:
		return
	_has_died = true

	var spawn_position: Vector2 = global_position + Vector2(0, magic_spawn_y_offset)
	var magic: Node = explosion_spawner.spawn(spawn_position, GameData.current_level_node)
	if GameData.everything_frozen and magic.has_method("freeze"):
		magic.freeze()

	queue_free()
