extends Node2D

@onready var player_flying = $"../PlayerFlying"
@onready var witch_spawner = $WitchSpawner
@onready var level_1 = $".."

var where_to_spawn = null
func _ready():
	witch_spawner.connect("witch_spawned", _on_witch_spawned)
	start_generating()

func _on_witch_spawned(witch_instance):
	if witch_instance.has_method("set_target"):
		witch_instance.set_target(player_flying)
		
func start_generating():
	witch_spawner.start_spawn(level_1)
