class_name WalkComponent
extends Node

@export var actor: Node2D
@export var velocity: Vector2

func _process(delta):
	actor.translate(velocity * delta)

func set_velocity(speed):
	velocity = speed
