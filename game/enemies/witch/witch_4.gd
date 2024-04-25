class_name Witch4

extends ShootingEnemy2

@onready var dress = $Dress
@onready var color_flicker_component = $ColorFlickerComponent
@onready var detection_area: Area2D = $DetectionArea
@onready var detection_shape = $DetectionArea/DetectionShape

enum states {FLYING, CHASING, FALLING}

var state = states.FLYING

var target_window = 8
var sight = 0

func _ready():
	super()
	detection_area.area_entered.connect(_on_detection_area_area_entered)
	
	speed = 64 + (randf() * 32)
	sight = randf() * 100
	move_component_2.set_mode("steady")
	move_component_2.set_speed(speed)
	dress.self_modulate = Color( sight / 300, 0, 1 - ( sight / 100 ))
	detection_shape.shape = detection_shape.shape.duplicate()
	detection_shape.shape.radius = sight


func was_hit(_obstacle:HitboxComponent):
	die()

func chase():
	state = states.CHASING
	move_component_2.set_mode("chase")
	move_component_2.set_mode_data("chase", [target, self])
	move_component_2.set_speed(speed)

func fall():
	state = states.FALLING
	move_component_2.set_mode("fall")
	fire_lock = true

func die():
	hurtbox_component.is_invincible = true
	color_flicker_component.enabled = true
	fall();
	GameData.set_score(GameData.score + 100)


func _on_detection_area_area_entered(_area: Area2D):
	if fire_lock:
		return
	if has_target && target != null && is_instance_valid(target):
		shoot()
		if state == states.FLYING:
			chase()
