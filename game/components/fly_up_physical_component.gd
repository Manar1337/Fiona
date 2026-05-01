class_name FlyUpPhysicalComponent
extends Node

@export var move_physical_component_path: NodePath
@export var speed: float = -150.0

var move_physical_component: MovePhysicalComponent

func _ready():
	move_physical_component = get_node(move_physical_component_path) as MovePhysicalComponent

func fly_up():
	print("FlyUpPhysicalComponent: fly_up called")
	if  move_physical_component == null:
		print("ERROR: MoveComponent is not defined in fly_component")
		return
	
	if not move_physical_component.get_modes().has("steady"):
		print("ERROR: MoveComponent does not have a steady mode")
		return
	
	move_physical_component.set_mode("steady")
	move_physical_component.set_speed(128)
	move_physical_component.set_mode_data([Vector2(0,-1)])
	move_physical_component.start()
