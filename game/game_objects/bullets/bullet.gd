class_name Bullet
extends GameObject

func _ready():
	print("Bullet ready: ", self.global_position)
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(on_hit.unbind(1))
	SignalHandler.freeze_everything.connect(_on_freeze_everything)

func set_speed(speed):
	move_component.set_speed(speed)

func set_direction(direction):
	move_component.set_mode_data([direction])

#func on_hit():
#	queue_free()

