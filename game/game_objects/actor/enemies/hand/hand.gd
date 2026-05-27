class_name Hand
extends Actor

@export var move_speed: float = 100.0
@export var landing_y: float = 184.0
@export var fall_spawns_pickup_magic: bool = true

const MAGIC_SCENE: PackedScene = preload("res://game/game_objects/items/magic/magic.tscn")

enum states {FLYING, FALLING}

var state = states.FLYING
var _fall_resolved: bool = false
var _has_entered_screen: bool = false

func _ready():
	hitbox_component.hit_hurtbox.connect(on_hit.unbind(1))
	SignalHandler.freeze_everything.connect(_on_freeze_everything)
	hurtbox_component.hurt.connect(_on_hurt)
	visible_on_screen_enabler_2d.screen_entered.connect(_on_screen_entered)
	visible_on_screen_enabler_2d.screen_exited.connect(_on_screen_exited)
	add_to_group("enemies")
	_start_flying()

func _process(_delta: float) -> void:
	if is_frozen:
		return
	if state == states.FALLING and fall_spawns_pickup_magic and not _fall_resolved and global_position.y >= landing_y:
		_resolve_fall_landing()

func was_hit(_obstacle: HitboxComponent):
	die()

func die():
	if hurtbox_component.is_invincible:
		return
	hurtbox_component.is_invincible = true
	hitbox_component.is_harmless = true
	state = states.FALLING
	_fall_resolved = false
	move_component.set_mode("fall")

func _start_flying() -> void:
	state = states.FLYING
	_fall_resolved = false
	move_component.set_mode("steady")
	move_component.set_speed(move_speed)
	move_component.set_mode_data([Vector2.RIGHT])
	move_component.start()

func _resolve_fall_landing() -> void:
	_fall_resolved = true
	global_position.y = landing_y
	var magic: Node2D = MAGIC_SCENE.instantiate()
	GameData.current_level_node.add_child(magic)
	magic.global_position = global_position
	queue_free()

func _on_screen_entered() -> void:
	_has_entered_screen = true

func _on_screen_exited() -> void:
	if _has_entered_screen:
		queue_free()
