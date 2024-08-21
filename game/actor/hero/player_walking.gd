extends CharacterBody2D

@onready var body: AnimatedSprite2D = $Body
@onready var dress: AnimatedSprite2D = $Dress
@onready var stats_component = $StatsComponent
@onready var movement_component = $MovementComponent
@onready var zap_marker = $ZapMarker as Marker2D
@onready var fire_rate_timer = $SpawnerComponent/FireRateTimer as Timer
@onready var spawner_component = $SpawnerComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var hitbox_component: = $HitboxComponent
@onready var big_explosion_spawner: = $BigExplosionSpawner
@onready var color_flicker_component: = $ColorFlickerComponent


var fire_lock = false
var dir = "left"

var carries_magic = false;
var is_alive = true

func _ready():
	#stats_component.health_changed.connect(get_hurt)
	hurtbox_component.hurt.connect(got_hurt.unbind(1))
	movement_component.connect("turn", on_turn)
	fire_rate_timer.timeout.connect(unlock_fire)
	stats_component.no_magic.connect(explode)
	dress.self_modulate = Color8(96,96,96,255)

func set_carries_magic(does_carry):
	carries_magic = does_carry

func got_hurt():
	print("Ouch")

func on_turn(direction):
	dir = direction;
	if(direction=="left"):
		body.flip_h = false
		dress.flip_h = false
		zap_marker.transform.origin.x = 7

	if(direction=="right"):
		body.flip_h = true
		dress.flip_h = true
		zap_marker.transform.origin.x = -7

func _input(_event: InputEvent):
	if Input.is_action_pressed("ui_select"):
		if !fire_lock:
			fire_zap()

func fire_zap():
	var zap = spawner_component.spawn(zap_marker.global_position)
	if dir =="left":
		zap.set_speed(500)
		zap.set_direction([Vector2(1,0)])
	if dir =="right":
		zap.set_speed(500)
		zap.set_direction([Vector2(-1,0)])
	lock_fire()

func lock_fire():
	fire_lock = true
	fire_rate_timer.start(1)

func unlock_fire():
	fire_lock = false;

func explode():
	print("explode")
	is_alive = false
	hurtbox_component.is_invincible = true
	color_flicker_component.enabled = true
	movement_component.is_alive = false
	await get_tree().create_timer(2.0).timeout
	die()

func die():
	body.visible = false
	dress.visible = false
	stats_component.lose_life()
	big_explosion_spawner.spawn(global_position)
	await get_tree().create_timer(1.0).timeout
	GameData.show_death_message(true)
	print("You Died!!!")

func hide_areas():
	body.visible = false
	hitbox_component.visible = false
