class_name GameObject
extends Node2D

@onready var visible_on_screen_enabler_2d = $VisibleOnScreenEnabler2D
@onready var move_component: MoveComponent = $MoveComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent

var is_frozen: bool = false

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(on_hit.unbind(1))
	SignalHandler.freeze_everything.connect(_on_freeze_everything)

func on_hit():
	queue_free()

func get_height() -> int:
	return 32

func freeze():
	is_frozen = true
	move_component.stop()
	hitbox_component.set_enabled(false)

func unfreeze():
	is_frozen = false
	move_component.start()
	hitbox_component.set_enabled(true)

func _on_freeze_everything(will_freeze: bool) -> void:
	print("GameObject freeze signal received: ", is_frozen)
	if will_freeze:
		freeze()
	else:
		unfreeze()
