class_name PlayerWalking

extends CharacterBody2D

@export var invincible: bool = false
@export var hovering: bool = false

@onready var body: AnimatedSprite2D = $Body
@onready var dress: AnimatedSprite2D = $Dress
@onready var zap_marker: Marker2D = $ZapMarker
@onready var fire_rate_timer: Timer = $SpawnerComponent/FireRateTimer
@onready var spawner: SpawnerComponent = $SpawnerComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var big_explosion_spawner: BigExplosionSpawner = $BigExplosionSpawner
@onready var color_flicker_component: ColorFlickerComponent = $ColorFlickerComponent
@onready var player_stats_component: PlayerStatsComponent = $PlayerStatsComponent
@onready var move_physical_component: MovePhysicalComponent = $MovePhysicalComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent

var is_alive := true
var fire_lock := false
var carries_magic := false
var direction := "left"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var light_gravity = gravity/2.0
var heavy_gravity = gravity * 5.0

func _ready() -> void:
	dress.self_modulate = Color8(96, 96, 96)  # Ensure the dress starts with the correct color
	_setup_components()
	_connect_signals()

func _input(_event: InputEvent):
	if is_alive and Input.is_action_pressed("fire") and not fire_lock:
		_fire_zap()

func _setup_components() -> void:
	hurtbox_component.is_invincible = invincible or (TestSettings.is_available() and TestSettings.fiona_invulnerable)
	if TestSettings.is_available():
		player_stats_component.magic = TestSettings.start_spellpower
	move_physical_component.set_mode("controlled")
	move_physical_component.set_gravity(light_gravity)
	move_physical_component.set_is_hovering(hovering)


func _connect_signals() -> void:
	SignalHandler.freeze_everything.connect(_on_freeze_everything)
	fire_rate_timer.timeout.connect(_on_fire_rate_timeout)
	player_stats_component.no_magic.connect(_on_no_magic)
	move_physical_component.turn.connect(_on_turn)

func _on_turn(dir: String):
	direction = dir
	var flip := direction == "right"
	body.flip_h = flip
	dress.flip_h = flip
	if flip:
		zap_marker.position.x = -7
	else:
		zap_marker.position.x = 7

func _fire_zap():
	var zap = spawner.spawn(zap_marker.global_position, GameData.current_level_node)
	zap.set_speed(500)
	if direction == "left":
		zap.set_direction(Vector2.RIGHT)
	else:
		zap.set_direction(Vector2.LEFT)
	_lock_fire()

func _lock_fire():
	fire_lock = true
	fire_rate_timer.start(1)

func _on_fire_rate_timeout():
	fire_lock = false

func _on_no_magic():
	die()

func die():
	is_alive = false
	hurtbox.is_invincible = true
	color_flicker_component.enabled = true
	move_physical_component.set_mode_data([false])

	get_parent().handle_player_death(global_position)

func hide_player():
	body.visible = false
	dress.visible = false
	hitbox.visible = false

func set_carries_magic(value: bool):
	carries_magic = value

func _on_freeze_everything(is_frozen: bool) -> void:
	if is_frozen:
		_freeze()
	else:
		_unfreeze()

func _freeze() -> void:
	move_physical_component.set_speed(0)
	hurtbox_component.set_enabled(false)
	fire_lock = true
	hurtbox_component.is_invincible = true

func _unfreeze() -> void:
	move_physical_component.start()
	hurtbox_component.set_enabled(true)
	fire_lock = false
	hurtbox_component.is_invincible = invincible or (TestSettings.is_available() and TestSettings.fiona_invulnerable)
