extends Node3D

@export var scenes: Array[RoomResource]

var scenes_list = {}
var rng = RandomNumberGenerator.new()
var next_room = null


func _ready() -> void:
	for scene in scenes:
		scenes_list[scene.room_id] = scene


func changeScene() -> void:
	get_tree().change_scene_to_packed(next_room)


func random_scene() -> void:
	rng.randomize()
	var packed = scenes[rng.randi_range(0, scenes.size() - 1)]
	next_room = packed