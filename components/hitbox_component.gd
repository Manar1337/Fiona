# Give the component a class name so it can be instanced as a custom node
class_name HitboxComponent
extends Area2D

# Export the damage amount this hitbox deals
@export var damage = 1

# Create a signal for when the hitbox hits a hurtbox
signal hit_hurtbox(hurtbox)

func _ready():
	# Connect on area entered to our hurtbox entered function
	area_entered.connect(_on_hurtbox_entered)

func _on_hurtbox_entered(hurtbox: Area2D):
	# Make sure the area we are overlapping is a hurtbox
	if not hurtbox is HurtboxComponent: return
	# Make sure the hurtbox isn't invincible
	if hurtbox.is_invincible: return
	# Signal out that we hit a hurtbox (this is useful for destroying projectiles when they hit something)
	hit_hurtbox.emit(hurtbox)
	# Have the hurtbox signal out that it was hit
	hurtbox.hurt.emit(self)
	
var is_harmless = false :
	# Here we create an inline setter so we can disable and enable collision shapes on
	# the hurtbox when is_invincible is changed.
	set(value):
		is_harmless = value
		# Disable any collisions shapes on this hurtbox when it is invincible
		# And reenable them when it isn't invincible
		for child in get_children():
			if not child is CollisionShape2D and not child is CollisionPolygon2D: continue
			# Use call deferred to make sure this doesn't happen in the middle of the
			# physics process
			child.set_deferred("disabled", is_harmless)
