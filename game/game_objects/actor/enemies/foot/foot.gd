class_name Foot

extends ShootingGravityActor

@export var blood_bomb_launch_rise_distance: float = 32.0

const MAGIC_SCENE: PackedScene = preload("res://game/game_objects/items/magic/magic.tscn")

var _jump_start_y: float = 0.0
var _was_on_floor: bool = false
var _has_launched_blood_bomb: bool = false
var _is_dying: bool = false

func _ready():
	super()
	add_to_group("enemies")
	_jump_start_y = global_position.y
	move_physical_component.set_gravity(gravity * 0.275)
	move_physical_component.set_mode("jump")
	fire_rate_timer.stop()

func _physics_process(_delta):
	if is_on_floor():
		if not _was_on_floor:
			_jump_start_y = global_position.y
		_has_launched_blood_bomb = false
		move_physical_component.set_mode_data([true])		
		move_physical_component.set_mode("jump")
	elif not _has_launched_blood_bomb and velocity.y < 0.0 and global_position.y <= _jump_start_y - blood_bomb_launch_rise_distance:
		_launch_blood_bomb()

	_was_on_floor = is_on_floor()

func was_hit(obstacle: HitboxComponent):
	if obstacle == null:
		return
	if _is_dying:
		return
	_is_dying = true
	call_deferred("die")

func shoot():
	pass

func _launch_blood_bomb() -> void:
	_has_launched_blood_bomb = true
	var blood_bomb = spawner_component.spawn(shooting_marker.global_position, GameData.current_level_node)
	if blood_bomb:
		blood_bomb.add_to_group("bullet")
	if blood_bomb and blood_bomb.has_method("launch"):
		blood_bomb.launch(_jump_start_y)

func die():
	var magic: Node2D = MAGIC_SCENE.instantiate()
	GameData.current_level_node.add_child(magic)
	magic.global_position = global_position
	GameData.score += score
	queue_free()
