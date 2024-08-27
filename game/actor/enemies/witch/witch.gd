class_name Witch
extends ShootingActor

@onready var dress = $Dress
@onready var color_flicker_component = $ColorFlickerComponent
@onready var detection_area: Area2D = $DetectionArea
@onready var detection_shape = $DetectionArea/DetectionShape
@onready var explosion_spawner: SpawnerComponent = $ExplosionSpawner

enum states {FLYING, CHASING, FALLING}

var state = states.FLYING

var target_window = 8
var sight = 0

func _ready():
	super()
	hitbox_component.hit_hurtbox.connect(Callable(self, "explode"))
	detection_area.area_entered.connect(_on_detection_area_area_entered)

	sight = randf() * 100
	move_component.set_speed(64 + (randf() * 32))
	dress.self_modulate = Color(sight / 300, 0, 1 - (sight / 100))
	detection_shape.shape = detection_shape.shape.duplicate()
	detection_shape.shape.radius = sight

func set_state(new_state):
	state = new_state
	match state:
		states.CHASING:
			move_component.set_mode("chase")
			move_component.set_mode_data([target, self])
		states.FALLING:
			move_component.set_mode("fall")
			fire_lock = true
		states.FLYING:
			move_component.set_mode("fly")

func was_hit(_obstacle: HitboxComponent):
	die()

func die(_unused: Variant = null):
	if hurtbox_component.is_invincible:
		return
	hurtbox_component.is_invincible = true
	color_flicker_component.enabled = true
	set_state(states.FALLING)
	GameData.score += score

func explode(_unused: Variant = null):
	call_deferred("spawn_explosion")

func spawn_explosion():
	explosion_spawner.spawn(global_transform.origin, GameData.current_level)
	queue_free()

func _on_detection_area_area_entered(_area: Area2D):
	if fire_lock or not has_target or not is_instance_valid(target):
		return
	shoot()
	if state == states.FLYING:
		set_state(states.CHASING)
