# Give the component a class name so it can be instanced as a custom node
class_name HurtboxComponent
extends Area2D

signal tilemap_hit(tilemap)
#signal hitbox_hit(hitbox)
signal hurt(hitbox)

func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _on_area_entered(area: Area2D):
	if not area is HitboxComponent: return
	if area.is_harmless: return

	# Have the hurtbox signal out that it was hit
	hurt.emit(area)

func _on_body_entered(tilemap:  Node2D):
	if not tilemap is TileMapLayer: return
	if self.is_invincible: return
	tilemap_hit.emit(tilemap)

# Create the is_invincible boolean
var is_invincible = false :
	# Here we create an inline setter so we can disable and enable collision shapes on
	# the hurtbox when is_invincible is changed.
	set(value):
		is_invincible = value
		# Disable any collisions shapes on this hurtbox when it is invincible
		# And reenable them when it isn't invincible
		for child in get_children():
			if not child is CollisionShape2D and not child is CollisionPolygon2D: continue
			# Use call deferred to make sure this doesn't happen in the middle of the
			# physics process
			child.set_deferred("disabled", is_invincible)
