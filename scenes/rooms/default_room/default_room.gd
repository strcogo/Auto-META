extends Node3D

const ENEMY_SCENES: Dictionary = {
	"ENEMY_BASE": preload("res://enemies/enemy_base/enemy_test.tscn")
}

@onready var tilemap: GridMap = $NavigationRegion3D/GridMap
@onready var door_container: Node3D = $Doors
@onready var door_positions: Node3D = $DoorsPosition
@onready var enemies_node: Node3D = $Enemies
@onready var player_detector: Area3D = $PlayerDetector
@onready var audio_manager: Node2D = $"../AudioManager"

var num_enemies: int

func _ready() -> void:
	num_enemies = enemies_node.get_child_count()
	

func _open_doors() -> void:
	for markers in door_positions.get_children():
		var cell_map_coords = tilemap.local_to_map(markers.global_position)
		tilemap.set_cell_item(cell_map_coords, -1)
		
		
func _close_doors() -> void:
	for markers in door_positions.get_children():
		var cell_map_coords = tilemap.local_to_map(markers.global_position)
		tilemap.set_cell_item(cell_map_coords, 2)


func _spawn_enemies() -> void:
	for enemy_position in enemies_node.get_children():
		var enemy: CharacterBody3D = ENEMY_SCENES.ENEMY_BASE.instantiate()
		var __ = enemy.connect("tree_exited", self._on_enemy_killed)
		enemy.global_position = enemy_position.position
		call_deferred("add_child", enemy)
		
	
func _on_enemy_killed() -> void:
	num_enemies	 -= 1
	if(num_enemies == 0):
		_open_doors()


func _on_player_detector_body_entered(body: CharacterBody3D) -> void:
	if(body.has_method("player")):
		player_detector.queue_free()
		_close_doors()
		_spawn_enemies()
