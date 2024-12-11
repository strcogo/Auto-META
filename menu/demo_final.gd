extends Control

@onready var menu: PackedScene = load("res://menu/menu.tscn") 

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_accept")):
		SceneTransition.transition()
		await SceneTransition.on_transition_finished
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_packed(menu)
