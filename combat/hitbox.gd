class_name HitBox
extends Area3D

@export var damage: int


func _init() -> void:
	collision_layer = 2
	collision_mask = 0
