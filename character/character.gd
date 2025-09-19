extends CharacterBody3D

# Bartolomeu Character Script

# Onready variables for nodes in the scene tree
@onready var health_bar = $CanvasLayer/HealthBar
@onready var audio_manager: Node2D = $"../AudioManager"
@onready var camera: Node3D = $CameraPivot/Camera
@onready var anim: AnimationPlayer = $"Pivot/mais-um-teste/AnimationPlayer"

# Export variables for the character's properties
@export var speed = 10.0
@export var life = 10.0

# Export variables for jump mechanics
@export var jump_velocity = 25.0
@export var max_jumps = 2

# Export variables for dodge mechanics
@export var dodge_duration = 0.3
@export var iframes_duration = 0.1
@export var dodge_cooldown = 0.25
@export var dodge_speed = 15.0

# Export variables for the lunge attack
@export var lunge_length = 0.15
@export var lunge_speed = 50.0

# Physics variables
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction = Vector3.ZERO
var last_direction = Vector3.ZERO
var target_speed = speed
var target_velocity = Vector3.ZERO

# Internal variables for character state
var attack_press_ticker = 0.0
var is_attacking = false
var is_lunging = false

var left_jumps = max_jumps
var can_jump = true

var is_dodging = false
var can_dodge = true

var is_invincible = false


# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Default direction facing forward
	direction = Vector3(0, 0, -1)
	last_direction = direction
	# Initialize the character's health bar
	health_bar.init_health(life)
	# Set the mouse mode to hidden
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


# Function to handle the dodge action
func handle_dodge():
	if(Input.is_action_just_pressed("dodge") and !is_dodging and can_dodge):
		direction = last_direction
		direction.y = 0
		
		is_dodging = true
		can_dodge = false
		is_invincible = true
		
		# Redo
		await get_tree().create_timer(dodge_duration).timeout
		is_dodging = false
		#

		await get_tree().create_timer(dodge_cooldown).timeout
		can_dodge = true


# Function to handle character movement
func handle_movement() -> void:
	if(!is_attacking and !is_lunging and !is_dodging):
		direction = Vector3.ZERO
		direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		direction.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		if(direction != Vector3.ZERO):
			direction = direction.normalized()
			$Pivot.basis = Basis.looking_at(direction)
			anim.play("walk")


# Function to handle the attack action
func handle_attack() -> void:

	# Charged attack handling
	if(Input.is_action_pressed("attack") and !is_attacking):
		attack_press_ticker += 1
		if(attack_press_ticker == 15.0):
			left_jumps -= 1
			if(left_jumps > 0):
				is_attacking = true
				target_velocity.y = jump_velocity
				anim.play("slash1")
				await anim.animation_finished
				is_attacking = false
			attack_press_ticker = 0.0

	# Normal attack handling
	if(Input.is_action_just_released("attack") and !is_attacking):
		if(attack_press_ticker < 20): 
			attack_press_ticker = 0.0
			is_attacking = true

			# Lunge attack
			if(Input.is_action_pressed("special") and is_on_floor()):
				direction = last_direction
				direction.y = 0
				is_lunging = true
				await get_tree().create_timer(lunge_length).timeout
				is_lunging = false

			# Stomp attack
			elif(!is_on_floor()):
				target_velocity.y -= 1.35 * gravity
				
			anim.play("slash1")
			await anim.animation_finished
			is_attacking = false


# Function to handle physics processing
# This function is called every physics frame
func _physics_process(delta: float) -> void:
	# Apply gravity to the character		
	if(!is_on_floor() and !is_attacking):
		target_velocity.y -= gravity * delta
	
	# Reset jump count if the character is on the floor
	if(is_on_floor()):
		left_jumps = max_jumps
	
	handle_movement()

	# Idle animation handling
	if(Input.get_vector("move_left", "move_right", "move_up", "move_down") == Vector2(0, 0) and !is_attacking):
		anim.play("idle")

	# Last direction handling for dodge and attack to go in the right direction
	if(Input.get_vector("move_left", "move_right", "move_up", "move_down") != Vector2(0, 0) and !is_dodging and !is_lunging):
		last_direction = direction
	
	# Attack handling
	handle_attack()
	
	# Dodge handling
	handle_dodge()

	# Set the target speed based on the character's state
	if(is_dodging):
		target_speed = dodge_speed
	elif(is_lunging):
		target_speed = lunge_speed
	elif(is_attacking):
		target_speed = 0.0
	else:
		target_speed = speed

	# Jump handling
	if(!is_attacking and Input.is_action_just_pressed("jump") and left_jumps > 0):
		left_jumps -= 1
		target_velocity.y = jump_velocity
	
	# Apply the target speed to the character's velocity if not attacking
	target_velocity.x = direction.x * target_speed
	target_velocity.z = direction.z * target_speed
		
	# Apply the velocity to the character	
	velocity = target_velocity
	move_and_slide()


# Function that makes the character able to getting damaged
func take_damage(amount: float) -> void:
	Hitstop.hit_stop(amount / 10)
	MusicPlayer.play_FX(load("res://audio/FX/damage.mp3"))
	camera.add_duration(amount / 5)
	life -= amount
	health_bar._set_life(life)
	health_bar.life = life

	# Temp death screen
	if(life <= 0):
		SceneTransition.transition()
		await SceneTransition.on_transition_finished
		MusicPlayer.play_FX(load("res://audio/FX/die.mp3"))
		get_tree().change_scene_to_file("res://menu/game_over.tscn")
	#


# Function to identify this node as a player character
func player() -> void:
	pass	
