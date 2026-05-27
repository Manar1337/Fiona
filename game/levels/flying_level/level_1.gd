class_name Level1

extends FlyingLevel

func _ready() -> void:
	super._ready()
	flight_timer.wait_time = flight_time
	
	GameData.spellpower = TestSettings.start_spellpower if TestSettings.is_available() else 2000

func _input(_event):
	if Input.is_action_just_pressed("clear_level"):
		stop_level()
