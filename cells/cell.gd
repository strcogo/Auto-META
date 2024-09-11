extends Node3D
class_name Cell

const GRID_SIZE = 2

@onready var floor = $floor
@onready var up_face = $wall_u
@onready var down_face = $wall_d
@onready var right_face = $wall_r
@onready var left_face = $wall_l


func update_faces(cell_list: Array) -> void:
	var my_grid_pos = Vector2i(position.x / GRID_SIZE, position.z / GRID_SIZE)
	if(cell_list.has(my_grid_pos + Vector2i.RIGHT)):
		right_face.queue_free()
	if(cell_list.has(my_grid_pos + Vector2i.LEFT)):
		left_face.queue_free()
	if(cell_list.has(my_grid_pos + Vector2i.UP)):
		up_face.queue_free()
	if(cell_list.has(my_grid_pos + Vector2i.DOWN)):
		down_face.queue_free()	
