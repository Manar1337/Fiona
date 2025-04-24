class_name SpawnerComponent
extends Node2D

@export var what_to_spawn: PackedScene

func spawn(global_spawn_position: Vector2, parent: Node):
	assert(what_to_spawn is PackedScene, "Error: The scene export was never set on this spawner component.")

	var instance = what_to_spawn.instantiate()
	parent.add_child(instance)
	instance.global_position = global_spawn_position

	return instance
