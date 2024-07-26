extends Node3D


const ENEMY_SCENES: Dictionary = {
	"ENEMY_BASE": preload("res://enemies/enemy_1 (runner)/enemy1.tscn")
}

var num_enemies: int
@onready var tilemap: GridMap = $NavigationRegion3D/GridMap
@onready var door_container: Node3D = $Doors
@onready var door_positions: Node3D = $DoorsPosition
@onready var enemies_node: Node3D = $Enemies
@onready var player_detector: Area3D = $PlayerDetector


func _ready():
	num_enemies = enemies_node.get_child_count()
	

func _open_doors():
	for markers in door_positions.get_children():
		tilemap.set_cell_item(markers.global_position, -1)
		
		
func _close_doors():
	for markers in door_positions.get_children():
		tilemap.set_cell_item(markers.global_position, 2)


func _spawn_enemies():
	for enemy_position in enemies_node.get_children():
		var enemy: CharacterBody3D = ENEMY_SCENES.ENEMY_BASE.instantiate()
		var __ = enemy.connect("tree_exited", self._on_enemy_killed)
		enemy.global_position = enemy_position.position
		call_deferred("add_child", enemy)
		
		
func _on_enemy_killed():
	num_enemies	 -= 1
	if num_enemies == 0:
		_open_doors()


func _on_player_detector_body_entered(body):
	if(body.has_method("player")):
		player_detector.queue_free()
		_close_doors()
		_spawn_enemies()
