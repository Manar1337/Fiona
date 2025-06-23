class_name PlayerFlying
extends Node2D

signal has_landed()

@export var invincible: bool = false

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var zap_marker: Marker2D = $ZapMarker
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var player_stats_component: PlayerStatsComponent = $PlayerStatsComponent
@onready var move_component: MoveComponent = $MoveComponent
@onready var color_flicker_component: ColorFlickerComponent = $ColorFlickerComponent
@onready var dress: Sprite2D = $Dress
@onready var big_explosion_spawner: BigExplosionSpawner = $BigExplosionSpawner
@onready var body: AnimatedSprite2D = $Body
@onready var flight_timer: Timer = $"../FlightTimer"

var fire_lock := false
var is_alive := true
var is_landing := false

func _ready() -> void:
	_setup_components()
	_connect_signals()
	dress.self_modulate = Color8(96, 96, 96, 255)

func _process(_delta: float) -> void:
	if is_landing and position.y >= 188:
		_hide_player()

func _input(_event: InputEvent) -> void:
	if is_alive and Input.is_action_pressed("fire") and not fire_lock:
		_fire_zap()

func _setup_components() -> void:
	hurtbox_component.is_invincible = invincible
	move_component.set_mode("controlled")

func _connect_signals() -> void:
	SignalHandler.connect("freeze_everything", _on_freeze_everything)
	fire_rate_timer.timeout.connect(_unlock_fire)
	player_stats_component.no_magic.connect(die)
	hurtbox_component.tilemap_hit.connect(_on_tilemap_hit)
	flight_timer.timeout.connect(_land)

func _fire_zap() -> void:
	var bullet = spawner_component.spawn(zap_marker.global_position, GameData.current_level_node)
	bullet.add_to_group("bullet")
	_lock_fire()

func _lock_fire() -> void:
	fire_lock = true
	fire_rate_timer.start(0.1)

func _unlock_fire() -> void:
	fire_lock = false

func _on_tilemap_hit(_tilemap: Node) -> void:
	if is_landing:
		return
	if !is_alive:
		return
	die()

func die() -> void:
	is_alive = false
	GameData.spellpower = 0
	hurtbox_component.is_invincible = true
	color_flicker_component.enabled = true
	move_component.set_mode_data(false)

	get_parent().handle_player_death(global_position)

func _land() -> void:
	is_landing = true
	hurtbox_component.is_invincible = true
	fire_lock = true
	move_component.set_mode("fall")
	await get_tree().create_timer(5.0).timeout
	has_landed.emit()

func _hide_player() -> void:
	body.visible = false
	dress.visible = false

func _on_freeze_everything(is_frozen: bool) -> void:
	if is_frozen:
		_freeze()
	else:
		_unfreeze()

func _freeze() -> void:
	move_component.set_speed(0)
	hurtbox_component.set_enabled(false)
	fire_lock = true
	hurtbox_component.is_invincible = true

func _unfreeze() -> void:
	move_component.start()
	hurtbox_component.set_enabled(true)
	fire_lock = false
	hurtbox_component.is_invincible = invincible
