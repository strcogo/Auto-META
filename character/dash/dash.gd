extends Node3D


func start_dash(duration):
	$Timer.wait_time = duration
	$Timer.start()
	
	
func is_dashing():
	return !$Timer.is_stopped()
