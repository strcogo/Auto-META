extends Node3D


func _process(delta) -> void:
	var resolution = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	camera_movement(resolution, mouse_pos)


func camera_movement(resolution: Vector2, mouse_pos: Vector2) -> void:
	var res_y = int(resolution[0] / 2)
	var res_x = int(resolution[1] / 2)
	var y = mouse_pos[0]
	var x = mouse_pos[1]
	var lalau_y
	var lalau_x
	
	if(y >= res_y):
		lalau_y = y / res_y
	else:
		lalau_y = ((y / res_y) * -1 + 2) * -1
	if(x >= res_x):
		lalau_x = x / res_x
	else:
		lalau_x = (x / res_x + 1) * -1