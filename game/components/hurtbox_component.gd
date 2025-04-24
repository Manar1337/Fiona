class_name HurtboxComponent
extends Area2D

signal tilemap_hit(tilemap)
signal hurt(hitbox)

@export var debug_enabled: bool = false

var is_enabled: bool = true

# Internal backing variable for invincibility
var _is_invincible: bool = false

var is_invincible: bool:
	get:
		return _is_invincible
	set(value):
		_is_invincible = value
		# Disable or enable all collision shapes based on invincibility
		for child in get_children():
			if child is CollisionShape2D or child is CollisionPolygon2D:
				child.set_deferred("disabled", value)

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent and not area.is_harmless:
		hurt.emit(area)

func _on_body_entered(tilemap: Node2D) -> void:
	if tilemap is TileMapLayer and not is_invincible:
		if debug_enabled:
			print("Hurtbox entered tilemap: ", tilemap.name)
		tilemap_hit.emit(tilemap)

func set_enabled(enabled: bool) -> void:
	is_enabled = enabled
	set_deferred("disabled", not is_enabled)

	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.set_deferred("disabled", not is_enabled)

func set_invincible(state: bool) -> void:
	is_invincible = state

func toggle_invincible() -> void:
	is_invincible = !is_invincible
