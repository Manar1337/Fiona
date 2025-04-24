extends CharacterBody2D

@onready var body: AnimatedSprite2D = $Body
@onready var dress: AnimatedSprite2D = $Dress
@onready var zap_marker: Marker2D = $ZapMarker
@onready var fire_rate_timer: Timer = $SpawnerComponent/FireRateTimer
@onready var spawner: SpawnerComponent = $SpawnerComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var explosion_spawner: BigExplosionSpawner = $BigExplosionSpawner
@onready var flicker: ColorFlickerComponent = $ColorFlickerComponent
@onready var stats: PlayerStatsComponent = $PlayerStatsComponent
@onready var movement: PlayerWalkingMovement = $MovementComponent

var is_alive := true
var fire_locked := false
var carries_magic := false
var direction := "left"

func _ready():
	movement.turn.connect(_on_turn)
	fire_rate_timer.timeout.connect(_unlock_fire)
	stats.no_magic.connect(_explode)
	dress.self_modulate = Color8(96, 96, 96)

func _input(event: InputEvent):
	if is_alive and Input.is_action_pressed("fire") and not fire_locked:
		_fire_zap()

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
	var zap = spawner.spawn(zap_marker.global_position, GameData.current_level)
	zap.set_speed(500)
	if direction == "left":
		zap.set_direction(Vector2.RIGHT)
	else:
		zap.set_direction(Vector2.LEFT)
	_lock_fire()

func _lock_fire():
	fire_locked = true
	fire_rate_timer.start(1)

func _unlock_fire():
	fire_locked = false

func _explode():
	is_alive = false
	GameData.health = 0
	hurtbox.is_invincible = true
	flicker.enabled = true
	movement.is_alive = false
	await get_tree().create_timer(2.0).timeout
	_die()

func _die():
	_hide()
	explosion_spawner.spawn(global_position, GameData.current_level)
	await get_tree().create_timer(1.0).timeout
	GameData.level_requested.emit("high_score")

func _hide():
	body.visible = false
	dress.visible = false
	hitbox.visible = false

func set_carries_magic(value: bool):
	carries_magic = value
