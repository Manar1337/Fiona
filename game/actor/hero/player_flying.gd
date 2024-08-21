class_name Player

extends Node2D
@onready var spawner_component = $SpawnerComponent as SpawnerComponent
@onready var fire_rate_timer = $FireRateTimer
@onready var zap_marker: Marker2D = $ZapMarker
@onready var hurtbox_component = $HurtboxComponent as HurtboxComponent
@onready var stats_component = $StatsComponent as StatsComponent
@onready var move_component: MoveComponent = $MoveComponent
@onready var color_flicker_component: ColorFlickerComponent = $ColorFlickerComponent
@onready var dress: Sprite2D = $Dress
@onready var big_explosion_spawner: BigExplosionSpawner = $BigExplosionSpawner
@onready var body: AnimatedSprite2D = $Body
@onready var flight_timer: Timer = $FlightTimer

var fire_lock = false
var is_alive = true

func _ready():
	hurtbox_component.is_invincible = true
	move_component.set_mode("controlled")
	fire_rate_timer.timeout.connect(unlock_fire)
	stats_component.no_magic.connect(explode)
	hurtbox_component.tilemap_hit.connect(hit_tilemap)
	dress.self_modulate = Color8(96,96,96,255)
	flight_timer.timeout.connect(land)

func _input(_event: InputEvent):
	if !is_alive: return
	if Input.is_action_pressed("ui_select"):
		if !fire_lock:
			fire_zap()

func fire_zap():
	spawner_component.spawn(zap_marker.global_position)
	lock_fire()

func lock_fire():
	fire_lock = true
	fire_rate_timer.start(0.1)

func unlock_fire():
	fire_lock = false;

func hit_tilemap(_tilemap):
	print("Hit tilemap")
	explode()

func explode():
	print("explode")
	is_alive = false
	GameData.health = 0
	hurtbox_component.is_invincible = true
	color_flicker_component.enabled = true
	move_component.set_mode_data(false)
	await get_tree().create_timer(2.0).timeout
	die()

func die():
	body.visible = false
	dress.visible = false
	big_explosion_spawner.spawn(global_position)
	await get_tree().create_timer(1.0).timeout
	GameData.show_death_message(true)
	print("You Died!!!")

func land():
	print("Landing")
