extends Control

@onready var controls = load("res://menu/controls.tscn")

func _ready() -> void:
	MusicPlayer.play_bg_music()


func _on_quit_button_pressed() -> void:
	SceneTransition.transition()
	await SceneTransition.on_transition_finished
	get_tree().quit()


func _on_play_button_pressed() -> void:
	SceneTransition.transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://Game.tscn")
	MusicPlayer.stop()


func _on_control_button_pressed() -> void:
	SceneTransition.transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_packed(controls)