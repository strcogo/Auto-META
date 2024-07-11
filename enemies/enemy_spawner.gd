extends Node3D

@export var enemy: PackedScene

func spawn():
	var spawned_enemy = enemy.instantiate()
	spawned_enemy.position = self.position
	self.add_child(spawned_enemy)

func _on_area_3d_body_entered(body):
	if(body.has_method("player")):
		spawn()
		$Area3D.queue_free()
		
