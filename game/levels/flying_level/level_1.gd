extends FlyingLevel

func _ready() -> void:
	super._ready()
	flight_timer.wait_time = flight_time
	
	GameData.health = 2000

func _input(_event):
	if Input.is_action_just_pressed("clear_level"):
		stop_level()
