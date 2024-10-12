class_name PlayerHitBox
extends Area3D

@export var damage: int


func _init() -> void:
	collision_layer = 4
	collision_mask = 0
