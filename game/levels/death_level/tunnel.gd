class_name Tunnel
extends Node2D

@export var wall_speed: float = 10.0
@export var escape_distance: float = 6660.0
@export var speed_increase_distance: float = 100.0
@export var speed_increase_amount: float = 5.0
@export var exit_sequence_distance: float = 398.0
@onready var wall_component_controller: WallComponentController = $WallComponentController

@onready var left_walls: LeftWalls = $LeftWalls
@onready var right_walls: RightWalls = $RightWalls

var is_moving: bool = true
var distance_left: float = 0.0
var has_escaped: bool = false
var next_speed_increase_at: float = 0.0
var exit_sequence_started: bool = false

func _ready() -> void:
	if TestSettings.is_available():
		wall_speed = TestSettings.tunnel_speed
		TestSettings.reset_tunnel_sequence()
	distance_left = escape_distance
	next_speed_increase_at = speed_increase_distance
	_emit_progress()
	SignalHandler.game_over.connect(_on_game_over)
	for i in range(10):
		wall_component_controller.make_next_wall_for_sequence()

	wall_component_controller.show_sequence()
	
func _process(_delta: float):
	if is_moving:
		distance_left = max(0.0, distance_left - wall_speed * _delta)
		_update_speed_ramp()
		_update_exit_sequence()
		_emit_progress()
		if distance_left <= 0.0 and not has_escaped:
			has_escaped = true
			stop_moving()
			SignalHandler.escaped_tunnel.emit()
			return
		move_down(wall_speed * _delta)

func move_down(speed: float):
	self.position += Vector2(0, speed)
	if self.position.y >= 133:
		flip_walls()
		self.position.y = 0

func flip_walls() -> void:
	var current_wall_component: WallComponent = wall_component_controller.get_current_wall_component()
	wall_component_controller.lower_first_wall_count()
	left_walls.flip_walls(current_wall_component)
	right_walls.flip_walls(current_wall_component)

func stop_moving() -> void:
	is_moving = false

func _on_game_over() -> void:
	stop_moving()

func _emit_progress() -> void:
	SignalHandler.death_tunnel_progress_changed.emit(int(ceil(distance_left)), int(escape_distance), wall_speed)

func _update_speed_ramp() -> void:
	if speed_increase_distance <= 0.0 or speed_increase_amount <= 0.0:
		return

	var distance_travelled = escape_distance - distance_left
	while distance_travelled >= next_speed_increase_at:
		wall_speed += speed_increase_amount
		next_speed_increase_at += speed_increase_distance

func _update_exit_sequence() -> void:
	if exit_sequence_started:
		return
	if distance_left > exit_sequence_distance:
		return

	exit_sequence_started = true
	wall_component_controller.force_wall_type("exit")
