extends Area3D

@onready var camera: Camera3D = $Camera3D
@onready var initial_rotation = camera.rotation_degrees as Vector3

var duration: float = 0.0
var time: float = 0.0
@export var duration_reduction_rate: float = 1.0
@export var noise: FastNoiseLite
@export var noise_speed: float = 50.0
@export var max_x: float = 10.0
@export var max_y: float = 10.0
@export var max_z: float = 5.0


func _process(delta: float) -> void:
	time += delta
	duration = max(duration - delta * duration_reduction_rate, 0.0)
	
	camera.rotation_degrees.x = initial_rotation.x + max_x * get_shake_intensity() * get_noise_from_seed(0)
	camera.rotation_degrees.y = initial_rotation.y + max_y * get_shake_intensity() * get_noise_from_seed(1)	
	camera.rotation_degrees.z = initial_rotation.z + max_z * get_shake_intensity() * get_noise_from_seed(2)


func add_duration(amount: float) -> void:
	duration = clamp(duration + amount, 0.0, 1.0)
	

func get_shake_intensity() -> float:
	return duration * duration
	

func get_noise_from_seed(_seed: int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)
	
	
