class_name PlayerBlasting
extends CharacterBody2D

signal escape_flyout_finished
signal death_sequence_finished

@export var speed: float = 50.0
@export var speed_increase_distance: float = 100.0
@export var speed_increase_amount: float = 3.0
@export var max_speed: float = 120.0
@export var margin: float = 8.0
@export var max_up_speed: float = 120.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_sensor: Area2D = $WallSensor
@onready var color_flicker_component: ColorFlickerComponent = $ColorFlickerComponent
@onready var big_explosion_spawner: BigExplosionSpawner = $BigExplosionSpawner

var touching_walls := {}
var base_speed: float = 0.0
var current_tunnel_speed: float = 0.0
var is_escape_flying: bool = false
var escape_flyout_speed: float = 0.0
var is_dying: bool = false

func _ready() -> void:
	base_speed = speed
	current_tunnel_speed = speed
	wall_sensor.area_entered.connect(_on_wall_area_entered)
	wall_sensor.area_exited.connect(_on_wall_area_exited)
	SignalHandler.death_tunnel_progress_changed.connect(_on_death_tunnel_progress_changed)

func _physics_process(_delta: float) -> void:
	if is_dying:
		return

	if is_escape_flying:
		velocity = Vector2(0.0, -escape_flyout_speed)
		move_and_slide()
		if global_position.y + margin < 0.0:
			hide()
			is_escape_flying = false
			_on_escape_flyout_finished()
		return

	var horizontal_input = Input.get_axis("ui_left", "ui_right")
	var up_input = 1.0 if Input.is_action_pressed("ui_up") else 0.0
	var down_input = 1.0 if Input.is_action_pressed("ui_down") else 0.0
	var vertical_velocity = down_input * _get_down_speed() - up_input * _get_up_speed()

	velocity.x = horizontal_input * speed
	velocity.y = vertical_velocity
	move_and_slide()
	global_position.x = clamp(global_position.x, margin, 320.0 - margin)
	global_position.y = clamp(global_position.y, margin, 200.0 - margin)

func _on_wall_area_entered(area: Area2D) -> void:
	if not area is Wall:
		return
	if is_dying or is_escape_flying:
		return
	var was_touching = not touching_walls.is_empty()
	touching_walls[area] = true
	animated_sprite.self_modulate = Color.RED
	if not was_touching:
		print("Fiona hit wall: ", area.segment_type)
		get_parent().handle_player_death(global_position)

func _on_wall_area_exited(area: Area2D) -> void:
	if not touching_walls.has(area):
		return
	touching_walls.erase(area)
	if touching_walls.is_empty():
		animated_sprite.self_modulate = Color.WHITE

func _on_death_tunnel_progress_changed(distance_left: int, distance_total: int, tunnel_speed: float) -> void:
	current_tunnel_speed = tunnel_speed
	if speed_increase_distance <= 0.0 or speed_increase_amount <= 0.0:
		return

	var distance_travelled = distance_total - distance_left
	var speed_steps = floor(float(distance_travelled) / speed_increase_distance)
	speed = min(max_speed, base_speed + speed_steps * speed_increase_amount)

func _get_up_speed() -> float:
	return min(max_up_speed, speed)

func _get_down_speed() -> float:
	return max(speed, current_tunnel_speed)

func start_escape_flyout() -> Signal:
	if is_dying:
		return escape_flyout_finished
	is_escape_flying = true
	escape_flyout_speed = _get_up_speed()
	velocity = Vector2.ZERO
	touching_walls.clear()
	animated_sprite.self_modulate = Color.WHITE
	wall_sensor.monitoring = false
	return escape_flyout_finished

func _on_escape_flyout_finished() -> void:
	escape_flyout_finished.emit()

func start_death_sequence(global_death_position: Vector2) -> Signal:
	if is_dying:
		return death_sequence_finished

	is_dying = true
	velocity = Vector2.ZERO
	touching_walls.clear()
	animated_sprite.self_modulate = Color.WHITE
	wall_sensor.monitoring = false
	color_flicker_component.enabled = true

	var timer = get_tree().create_timer(1.0)
	timer.timeout.connect(func():
		hide_player()
		big_explosion_spawner.spawn(global_death_position, GameData.current_level_node)
		death_sequence_finished.emit()
	, CONNECT_ONE_SHOT)

	return death_sequence_finished

func hide_player() -> void:
	animated_sprite.visible = false
