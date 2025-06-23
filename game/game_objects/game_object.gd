class_name GameObject
extends Node2D

@onready var visible_on_screen_enabler_2d = $VisibleOnScreenEnabler2D
@onready var move_component: MoveComponent = $MoveComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(on_hit.unbind(1))
	SignalHandler.connect("freeze_everything", _on_freeze_everything)

func on_hit():
	queue_free()

func get_height() -> int:
	return 32

func freeze():
	move_component.stop()
	hitbox_component.set_enabled(false)

func unfreeze():
	move_component.start()
	hitbox_component.set_enabled(true)

func _on_freeze_everything(is_frozen: bool) -> void:
	print("GameObject freeze signal received: ", is_frozen)
	if is_frozen:
		freeze()
	else:
		unfreeze()
