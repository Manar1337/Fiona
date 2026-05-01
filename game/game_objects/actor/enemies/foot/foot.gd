class_name Foot

extends ShootingGravityActor

func _ready():
	super()
	add_to_group("enemies")
	move_physical_component.set_mode("jump")

func _physics_process(_delta):
	if is_on_floor():
		move_physical_component.set_mode_data([true])		
		move_physical_component.set_mode("jump")
