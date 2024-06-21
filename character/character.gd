extends CharacterBody3D


@export var speed = 10
var target_velocity = Vector3.ZERO
var dash_speed = speed * 5
var dash_lenght = .1


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
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	
	if Input.is_action_just_pressed("dash"):
		$Dash.start_dash(dash_lenght)
	var target_speed = dash_speed if $Dash.is_dashing() else speed
	target_velocity.x = direction.x * target_speed
	target_velocity.z = direction.z * target_speed
	velocity = target_velocity
	move_and_slide()
 
