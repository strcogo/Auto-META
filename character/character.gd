extends CharacterBody3D

@onready var health_bar = $CanvasLayer/HealthBar
@onready var audio_manager: Node2D = $"../AudioManager"
@onready var camera: Camera3D = $CameraPivot/Camera/Camera3D
@onready var anim: AnimationPlayer = $Pivot/bartolomeu/AnimationPlayer

@export var speed = 10
@export var life = 10
@export var jump_velocity = 25
@export var max_jumps = 2
@export var dodge_duration = 0.3
@export var iframes_duration = 0.1
@export var dodge_cooldown = 1.0
@export var dodge_speed = 15.0
@export var wall_slide_gravity = 2.0
@export var wall_jump_horizontal_force = 8.0
@export var wall_stick_time = 0.3

var press_ticker = 0.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target_velocity = Vector3.ZERO
var last_direction = Vector3.ZERO
var dash_speed = speed * 5
var dash_lenght = .1
var is_attacking = false
var left_jumps = max_jumps

var is_dodging = false
var can_dodge = true
var is_invincible = false

var is_wall_sliding = false
var wall_normal = Vector3.ZERO

func _ready() -> void:
	health_bar.init_health(life)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func start_dodge():
	var dodge_direction = last_direction
	dodge_direction.y = 0
	
	is_dodging = true
	can_dodge = false
	is_invincible = true
	
	await get_tree().create_timer(dodge_duration).timeout
	is_dodging = false
	await get_tree().create_timer(iframes_duration).timeout
	is_invincible = false
	
	await get_tree().create_timer(dodge_cooldown).timeout
	can_dodge = true


func _physics_process(delta) -> void:
			
	if(is_on_wall_only()):
		wall_normal = get_wall_normal()
		if(last_direction.dot(-wall_normal) > 0.5):
			target_velocity.y = -wall_slide_gravity
			is_wall_sliding = true
		else:
			is_wall_sliding = false
			
	if(!is_on_floor() and !is_attacking):
		var actual_gravity = wall_slide_gravity if is_wall_sliding else gravity
		target_velocity.y -= actual_gravity * delta
	
	if(is_on_floor()):
		left_jumps = max_jumps
	
	var direction = Vector3.ZERO
	
	if(!anim.is_playing()):
		anim.play("idle")
	
	if(!is_attacking and !$Dash.is_dashing() and !is_dodging and !is_wall_sliding):
		if(Input.is_action_pressed("move_up")):
			anim.play("walk")
			direction.x += 1
			direction.z += 1
		if(Input.is_action_pressed("move_down")):
			anim.play("walk")
			direction.x -= 1
			direction.z -= 1
		if(Input.is_action_pressed("move_right")):
			anim.play("walk")
			direction.z += 1
			direction.x -= 1
		if(Input.is_action_pressed("move_left")):
			anim.play("walk")
			direction.z -= 1
			direction.x += 1
			
	if(Input.get_vector("move_left", "move_right", "move_up", "move_down") != Vector2(0, 0) and !$Dash.is_dashing()):
		last_direction = direction
	
	if(Input.get_vector("move_left", "move_right", "move_up", "move_down") == Vector2(0, 0) and !is_attacking and !$Dash.is_dashing()):
		anim.play("idle")
	
	if(Input.is_action_pressed("attack") and !is_attacking):
		press_ticker += 1
		print(press_ticker)
		if(press_ticker == 15.0):
			if(is_on_floor()):
				is_attacking = true
				target_velocity.y = jump_velocity
				anim.play("walk")
				await anim.animation_finished
				is_attacking = false
			press_ticker = 0.0

	if(Input.is_action_just_released("attack") and !is_attacking):
		if(press_ticker < 20): 
			press_ticker = 0.0
			is_attacking = true
			if(Input.is_action_pressed("special") and is_on_floor()):
				$Dash.start_dash(dash_lenght)
				move_and_slide()
			elif(!is_on_floor()):
				target_velocity.y -= 1.35 * gravity
			anim.play("hit")
			await anim.animation_finished
			is_attacking = false
			
	if(direction != Vector3.ZERO and !is_attacking):
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	if(Input.is_action_just_pressed("dodge")):
		start_dodge()
	
	var target_speed = dash_speed if $Dash.is_dashing() else speed
	target_speed = dodge_speed if is_dodging else speed
	if(direction == Vector3(0, 0, 0) and ($Dash.is_dashing() or is_dodging)):
		direction = last_direction
		
	if(!is_attacking and Input.is_action_just_pressed("jump") and left_jumps > 0):
		if(!is_wall_sliding):
			left_jumps -= 1
			target_velocity.y = jump_velocity
		else:
			target_velocity.y = jump_velocity
			direction += wall_normal
			is_wall_sliding = false
			left_jumps = 1
	
	target_velocity.x = direction.x * target_speed
	target_velocity.z = direction.z * target_speed
	print(target_velocity, direction)
	velocity = target_velocity
	
	move_and_slide()


func take_damage(amount: float) -> void:
	if(!is_invincible):
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
