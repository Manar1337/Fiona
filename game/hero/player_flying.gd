class_name Player

extends Node2D

@onready var spawner_component = $SpawnerComponent as SpawnerComponent
@onready var fire_rate_timer = $FireRateTimer
@onready var zap_marker: Marker2D = $ZapMarker
@onready var hurtbox_component = $HurtboxComponent as HurtboxComponent
@onready var stats_component = $StatsComponent as StatsComponent

var fire_lock = false

func _ready():
	fire_rate_timer.timeout.connect(unlock_fire)
	hurtbox_component.tilemap_hit.connect(hit_tilemap)
	stats_component.health_changed.connect(get_hurt)
	stats_component.no_health.connect(die)
	
func _input(_event: InputEvent):
	if Input.is_action_pressed("ui_select"):
		if !fire_lock:
			fire_zap()

func fire_zap():
	spawner_component.spawn(zap_marker.global_position)
	lock_fire()
	
func lock_fire():
	fire_lock = true
	fire_rate_timer.start(1)

func unlock_fire():
	fire_lock = false;
	
func get_hurt():
	GameData.set_health(stats_component.health)
	
func hit_tilemap(_tilemap):
	die()

func die():
	print("You Died!!!")
