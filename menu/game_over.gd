extends Control

@onready var inicio = load("res://menu/menu.tscn")


func _on_timer_timeout() -> void:
	SceneTransition.transition()
	await SceneTransition.on_transition_finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_packed(inicio)
