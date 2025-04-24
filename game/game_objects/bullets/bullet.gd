class_name Bullet
extends GameObject

func _ready():
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(on_hit.unbind(1))
	GameData.connect("sprite_frozen", _on_sprite_frozen)

func set_speed(speed):
	move_component.set_speed(speed)

func set_direction(direction):
	move_component.set_mode_data([direction])

func on_hit():
	queue_free()

func _on_sprite_frozen(is_frozen):
	if is_frozen:
		freeze()
	else:
		unfreeze()
func freeze():
	move_component.set_speed(0)
	hitbox_component.set_enabled(false)
func unfreeze():
	move_component.start()
	hitbox_component.set_enabled(true)
