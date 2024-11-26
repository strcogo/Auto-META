extends AudioStreamPlayer2D

const music = preload("res://audio/music/chant.wav")


func _play_music(music: AudioStream, volume := 0.0) -> void:
	if(stream == music):
		return
	
	stream = music
	volume_db = volume
	play()


func play_bg_music() -> void:
	_play_music(music)
	

func play_FX(stream: AudioStream, volume := 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	
	fx_player.queue_free()
		
