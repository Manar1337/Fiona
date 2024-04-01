extends CharacterBody2D


@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D
@onready var stats_component = $StatsComponent
@onready var movement_component = $MovementComponent
@onready var zap_marker = $ZapMarker as Marker2D
@onready var fire_rate_timer = $SpawnerComponent/FireRateTimer as Timer
@onready var spawner_component = $SpawnerComponent

var fire_lock = false
var dir = "left"

func _ready():
	stats_component.health_changed.connect(get_hurt)
	movement_component.connect("turn", on_turn)
	fire_rate_timer.timeout.connect(unlock_fire)

func get_hurt():
	print("Ouch")
	
func on_turn(direction):
	dir = direction;
	if(direction=="left"):
		animated_sprite_2d.flip_h = false
		zap_marker.transform.origin.x = 7
		
	if(direction=="right"):
		animated_sprite_2d.flip_h = true
		zap_marker.transform.origin.x = -7
func _input(_event: InputEvent):
	if Input.is_action_pressed("ui_select"):
		if !fire_lock:
			fire_zap()

func fire_zap():
	var zap = spawner_component.spawn(zap_marker.global_position)
	if dir =="left":
		zap.set_speed(Vector2(300, 0))
	if dir =="right":
		zap.set_speed(Vector2(-300, 0))
	lock_fire()
	
func lock_fire():
	fire_lock = true
	fire_rate_timer.start(1)

func unlock_fire():
	fire_lock = false;
	
