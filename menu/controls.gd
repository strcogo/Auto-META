extends Control

@onready var menu = load("res://menu/menu.tscn")

func _on_back_button_pressed() -> void:
	SceneTransition.transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_packed(menu)
