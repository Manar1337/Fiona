extends Control

const GAME_SCENE = preload("res://game/game.tscn")
const GAME_VIEWPORT_SIZE := Vector2i(320, 200)

@onready var game_viewport_container: SubViewportContainer = $GameViewportContainer
@onready var game_viewport: SubViewport = $GameViewportContainer/GameViewport

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	game_viewport_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	game_viewport_container.stretch = false
	game_viewport.size = GAME_VIEWPORT_SIZE
	game_viewport_container.stretch_shrink = 4
	game_viewport_container.stretch = true

	if game_viewport.get_child_count() == 0:
		game_viewport.add_child(GAME_SCENE.instantiate())
