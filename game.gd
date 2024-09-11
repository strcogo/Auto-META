extends Node3D

const CELL = preload("res://cells/cell.tscn")
const GRID_SIZE = 2

@export var map: PackedScene

var cells = []

func _ready() -> void:
	paint_3d_map()
	

func paint_3d_map() -> void:
	if(!map is PackedScene): return
	var map_instance = map.instantiate()
	var tile_map = map_instance.get_tilemap()
	var used_tiles = tile_map.get_used_cells()
	map_instance.free()
	for tile in used_tiles:
		var cell = CELL.instantiate()
		add_child(cell)
		cell.position = Vector3(tile.x * GRID_SIZE, 0, tile.y * GRID_SIZE)
		cells.append(cell)
	for cell in cells:
		cell.update_faces(used_tiles)
