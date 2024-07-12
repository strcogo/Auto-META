extends Area3D

func _ready():
	collision_mask = 2

func _on_body_entered(body):
	if body.has_method("player"):
		var manager = body.get_node("RoomManager")
		manager.random_scene()
		manager.changeScene()
			
