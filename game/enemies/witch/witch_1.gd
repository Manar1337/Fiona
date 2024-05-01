class_name Witch1
extends Node2D

@onready var dress = $Dress as Sprite2D
@onready var move_component = $MoveComponent as MoveComponent
@onready var spawner_component = $SpawnerComponent as SpawnerComponent
@onready var fire_rate_timer = $FireRateTimer
@onready var zap_marker = $ZapMarker
@onready var visible_on_screen_enabler_2d = $VisibleOnScreenEnabler2D as VisibleOnScreenEnabler2D
@onready var hurtbox_component :HurtboxComponent = $HurtboxComponent as HurtboxComponent
@onready var hitbox_component = $HitboxComponent as HitboxComponent
@onready var color_flicker_component = $ColorFlickerComponent as ColorFlickerComponent

enum states {FLYING, CHASING, FALLING}

var target = null
var state = states.FLYING
var fire_lock = false

var target_window = 8
var speed = -64 + (randf() * -32)
var sight = randf() * 300

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hurtbox_component.hurt.connect(die.unbind(1))
	move_component.velocity.x = speed
	#dress.self_modulate = Color( randf(), randf(), randf(), 1)
	dress.self_modulate = Color( sight / 300, 0, 1 - ( sight / 300 ))
	fire_rate_timer.timeout.connect(unlock_fire)
	hitbox_component.hit_hurtbox.connect(die.unbind(1))

func _process(_delta):
	if state == states.FALLING:
		fall()
	if target != null && is_instance_valid(target):
		if state == states.CHASING:
			chase()
		if global_transform.origin.distance_to(target.global_transform.origin) < sight:
			if global_transform.origin.x > target.global_transform.origin.x + sight/3:
				if !fire_lock:
					fire_zap()
		if state == states.FLYING && global_transform.origin.distance_to(target.global_transform.origin) < sight:
			state = states.CHASING

func set_target(new_target):
	target = new_target

func fire_zap():
	var zap = spawner_component.spawn(zap_marker.global_position)
	zap.set_speed(Vector2(target.global_transform.origin - global_transform.origin).normalized() * 300)
	lock_fire()

func lock_fire():
	fire_lock = true
	fire_rate_timer.start(1)

func unlock_fire():
	fire_lock = false;

func chase():
	if target.global_position.y < global_position.y - target_window:
		move_component.velocity.y = speed
	elif target.global_position.y > global_position.y + target_window:
		move_component.velocity.y = -speed
	else: move_component.velocity.y = 0

func fall():
	move_component.velocity.x = 0
	move_component.velocity.y+=15

	fire_lock = true

func die():
	hurtbox_component.is_invincible = true
	color_flicker_component.enabled = true
	state = states.FALLING
	GameData.set_score(GameData.score + 100)


