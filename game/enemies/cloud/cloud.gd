class_name Cloud

extends ShootingActor

@onready var body: AnimatedSprite2D = $Body

var color = randf() * 0.8 + 0.2

func _ready():
	super()
	body.self_modulate = Color( color, color, color, 1)

func _process(_delta: float) -> void:
	if !fire_lock:
		shoot()
