class_name BigExplosionSpawner
extends Node2D

@export var what_to_spawn: PackedScene

func _ready():
	assert(what_to_spawn is PackedScene, "Error: The scene export was never set on this spawner component.")

func spawn(global_spawn_position: Vector2 = global_position, parent: Node = get_tree().current_scene):
	var directions = [
		Vector2(1, 0), Vector2(1, -1), Vector2(0, -1), Vector2(-1, -1),
		Vector2(-1, 0), Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1)
	]

	for dir in directions:
		call_deferred("spawn_in_direction", parent, global_spawn_position, dir)

func spawn_in_direction(parent: Node, global_spawn_position: Vector2, dir: Vector2):
	var instance = what_to_spawn.instantiate()
	parent.add_child(instance)
	if instance.has_method("set_direction"):
		instance.set_direction(dir)
	if instance.has_method("set_speed"):
		instance.set_speed(300)
	instance.global_position = global_spawn_position
