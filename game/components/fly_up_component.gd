class_name FlyUpComponent
extends Node

@export var move_component_path: NodePath
@export var speed: float = -150.0

var move_component: MoveComponent

func _ready():
	move_component = get_node(move_component_path) as MoveComponent

func fly_up():
	if  move_component == null:
		print("ERROR: MoveComponent is not defined in fly_component")
		return
	
	if not move_component.get_modes().has("steady"):
		print("ERROR: MoveComponent does not have a steady mode")
		return
	
	move_component.set_mode("steady")
	move_component.set_speed(128)
	move_component.set_mode_data([Vector2(0,-1)])
	move_component.start()
