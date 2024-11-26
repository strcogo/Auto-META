extends Node3D

const ENEMY_SCENES: Dictionary = {
	"HARPY": preload("res://enemies/harpy/harpy.tscn")
}

const DOOR_SCENE = preload("res://scenes/rooms/utility/door.tscn")

@export var next_room: PackedScene

@onready var door_container: Node3D = $Doors
@onready var enemies_node: Node3D = $Enemies
@onready var player_detector: Area3D = $PlayerDetector
@onready var change_detector: Area3D = $ChangeDetector
@onready var audio_manager: Node2D = $"../AudioManager"
@onready var player: CharacterBody3D = get_parent().get_node("Player")
@onready var player_position: Marker3D = $PlayerPos

var num_enemies: int

func _ready() -> void:
	player.position = player_position.position
	num_enemies = enemies_node.get_child_count()
	

func _open_doors() -> void:
	for door in door_container.get_children():
		door.open()
		
		
func _close_doors() -> void:
	for door in door_container.get_children():
		door.close()


func _spawn_enemies() -> void:
	for enemy_position in enemies_node.get_children():
		var enemy: CharacterBody3D = ENEMY_SCENES.HARPY.instantiate()
		var __ = enemy.connect("tree_exited", self._on_enemy_killed)
		enemy.scale = Vector3(0.2, 0.2, 0.2)
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
		
		
func _on_change_detector_body_exited(body: Node3D) -> void:
		if(body.has_method("player")):
			change_detector.queue_free()
			var r = next_room.instantiate()
			SceneTransition.transition()
			await SceneTransition.on_transition_finished
			get_parent().add_child(r)
			self.queue_free()
	
