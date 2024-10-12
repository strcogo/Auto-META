extends Node

func hit_stop(rate: float) -> void:
	Engine.time_scale = 0
	await get_tree().create_timer(rate, true, false, true).timeout
	Engine.time_scale = 1
