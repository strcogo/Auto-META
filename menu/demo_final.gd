extends Control

@onready var menu: PackedScene = load("res://menu/menu.tscn") 

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_accept")):
		SceneTransition.transition()
		await SceneTransition.on_transition_finished
		get_tree().quit()
