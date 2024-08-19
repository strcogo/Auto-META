extends Node2D

var audio_list = {}

@export var _audio_streams: Array[AudioResource]

func _ready() -> void:
	initialize()


func initialize() -> void:
	for stream in _audio_streams:
		audio_list[stream.stream_name] = stream


func play(stream_name: String) -> void:
	var instance = AudioStreamPlayer.new()
	instance.volume_db -= 20
	instance.stream = audio_list[stream_name].audio
	instance.finished.connect(remove_node)
	add_child(instance)
	instance.play()
	
	
func remove_node(instance: AudioStreamPlayer):
	instance.queue_free()
