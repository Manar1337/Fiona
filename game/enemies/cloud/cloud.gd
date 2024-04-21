extends Node2D
@onready var visible_on_screen_enabler_2d = $VisibleOnScreenEnabler2D as VisibleOnScreenEnabler2D
@onready var sprite_2d = $Sprite2D as Sprite2D
@onready var fire_rate_timer = $FireRateTimer as Timer
@onready var spawner_component = $SpawnerComponent as SpawnerComponent
@onready var zap_marker = $ZapMarker as Marker2D
@onready var move_component_2 = $MoveComponent2 as MoveComponent2

var color = randf() * 0.8 + 0.2
var speed = 32 + (randf() * 50)
var fire_lock = false

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	move_component_2.set_mode("steady")
	move_component_2.set_speed(speed)
	sprite_2d.self_modulate = Color( color, color, color, 1)

	fire_rate_timer.timeout.connect(unlock_fire)

func _process(_delta):
	if !fire_lock:
		fire_zap()

func fire_zap():
	var x_pos = zap_marker.global_position.x
	var y_pos = zap_marker.global_position.y
	var lightning = spawner_component.spawn(Vector2(randf_range(x_pos-24, x_pos + 24),y_pos))
	lightning.set_speed(Vector2(randf_range(50,100) +  speed,randf_range(100,200)))
	lock_fire()

func lock_fire():
	fire_lock = true
	fire_rate_timer.start(randf_range(1,5))

func unlock_fire():
	fire_lock = false;
