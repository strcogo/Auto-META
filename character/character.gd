extends CharacterBody3D


@export var speed = 10
@export var life = 125
var target_velocity = Vector3.ZERO
var dash_speed = speed * 5
var dash_lenght = .1
var is_attacking = false

@onready var health_bar = $CanvasLayer/HealthBar

func _ready():
	health_bar.init_health(life)


func _physics_process(delta):
	var direction = Vector3.ZERO
	var lastdirection = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1

	if(Input.is_action_just_pressed("attack")):
		$Pivot.basis = Basis.looking_at(mouse_position())
		is_attacking = true
		await $Pivot/WeaponManager/AnimationPlayer.animation_finished
		is_attacking = false
		
	if direction != Vector3.ZERO and !is_attacking:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	if Input.is_action_just_pressed("dash"):
		$Dash.start_dash(dash_lenght)
	
	var target_speed = dash_speed if $Dash.is_dashing() else speed
	
	if !is_attacking:
		target_velocity.x = direction.x * target_speed
		target_velocity.z = direction.z * target_speed
		velocity = target_velocity
		move_and_slide()
 
func mouse_position():
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = $MouseView.project_ray_origin(mouse_position)
	var ray_end = ray_origin + $MouseView.project_ray_normal(mouse_position) * 99999
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = space_state.intersect_ray(query)
	if(!intersection.is_empty()):
		var pos = intersection["position"]
		return Vector3(pos.x, 0, pos.z)

func take_damage(amount: int):
	life -= amount
	health_bar._set_life(life)
	health_bar.life = life

func player():
	pass	
