class_name GameObject
extends Node2D

@onready var visible_on_screen_enabler_2d = $VisibleOnScreenEnabler2D
@onready var move_component: MoveComponent = $MoveComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(on_hit.unbind(1))
	GameData.connect("sprite_frozen", _on_sprite_frozen)

func on_hit():
	queue_free()

func get_height() -> int:
	return 32

func fly_up():
	move_component.set_mode("steady")
	move_component.set_speed(128)
	move_component.set_mode_data([Vector2(0,-1)])

func freeze():
	move_component.set_speed(0)
	hitbox_component.set_enabled(false)

func unfreeze():
	move_component.start()
	hitbox_component.set_enabled(true)

func _on_sprite_frozen(is_frozen: bool) -> void:
	if is_frozen:
		freeze()
	else:
		unfreeze()
