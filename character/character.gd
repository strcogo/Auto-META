extends CharacterBody3D

@onready var health_bar = $CanvasLayer/HealthBar
@onready var audio_manager: Node2D = $"../AudioManager"
@onready var camera: Camera3D = $CameraPivot/Camera/Camera3D
@onready var cursor_camera: Camera3D = $CanvasLayer/SubViewportContainer/SubViewport/Camera3D2
@onready var cursor: MeshInstance3D = $Cursor
@onready var anim: AnimationPlayer = $Pivot/bartolomeu/AnimationPlayer
@onready var anim2: AnimationPlayer = $Pivot/bartolomeu2/AnimationPlayer

@export var speed = 10
@export var life = 10
var target_velocity = Vector3.ZERO
var dash_speed = speed * 5
var dash_lenght = .1
var is_attacking = false
var cursor_pos


func _ready() -> void:
	cursor.basis.looking_at(camera.position)
	health_bar.init_health(life)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _physics_process(delta) -> void:
	cursor_camera.global_transform = camera.global_transform
	
	var direction = Vector3.ZERO
	var last_direction = Vector3.ZERO
	_look_at_cursor()
	
	if(!anim.is_playing()):
		anim2.play("idle")
		anim.play("idle")
	
	if(!is_attacking):
		if(Input.is_action_pressed("move_up")):
			anim2.play("walk")
			anim.play("walk")
			direction.x += 1
			direction.z += 1
		if(Input.is_action_pressed("move_down")):
			anim2.play("walk")
			anim.play("walk")
			direction.x -= 1
			direction.z -= 1
		if(Input.is_action_pressed("move_right")):
			anim2.play("walk")
			anim.play("walk")
			direction.z += 1
			direction.x -= 1
		if(Input.is_action_pressed("move_left")):
			anim2.play("walk")
			anim.play("walk")
			direction.z -= 1
			direction.x += 1
	
	if(Input.get_vector("move_left", "move_right", "move_up", "move_down") == Vector2(0, 0) and !is_attacking):
		anim.play("idle")
		anim2.play("idle")
	

	if(Input.is_action_just_pressed("attack")):
		$Pivot.look_at(cursor_pos, Vector3.UP)
		is_attacking = true
		anim2.play("hit")
		anim.play("hit")
		await anim.animation_finished
		is_attacking = false
	if(direction != Vector3.ZERO and !is_attacking):
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	if(Input.is_action_just_pressed("dash")):
		$Dash.start_dash(dash_lenght)
	
	var target_speed = dash_speed if $Dash.is_dashing() else speed
	
	if(!is_attacking):
		target_velocity.x = direction.x * target_speed
		target_velocity.z = direction.z * target_speed
		velocity = target_velocity
		move_and_slide()


func _look_at_cursor():
	var player_pos = global_transform.origin
	var drop_plane = Plane(Vector3(0, 1, 0), player_pos.y)
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	cursor_pos = drop_plane.intersects_ray(from, to)
	cursor.global_transform.origin = cursor_pos + Vector3(0, 1, 0)


func take_damage(amount: float) -> void:
	Hitstop.hit_stop(amount / 10)
	MusicPlayer.play_FX(load("res://audio/FX/damage.mp3"))
	$CameraPivot/Camera.add_duration(amount / 10)
	life -= amount
	health_bar._set_life(life)
	health_bar.life = life
	if(life <= 0):
		SceneTransition.transition()
		await SceneTransition.on_transition_finished
		MusicPlayer.play_FX(load("res://audio/FX/die.mp3"))
		get_tree().change_scene_to_file("res://menu/game_over.tscn")


func player() -> void:
	pass	
