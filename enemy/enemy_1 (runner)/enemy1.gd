extends CharacterBody3D

var speed = 2
var accel = 10


@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var player = get_parent().get_parent().get_node("Player")


@onready var direction = Vector3()

enum {
	WALKING,
	ATACKING
}

var state = WALKING

func _physics_process(delta):
	
	match state:
		WALKING:
			nav.target_position = player.position 
	
			direction = nav.get_next_path_position() - global_position
			direction = direction.normalized()
			$Pivot.basis = Basis.looking_at(direction)

			velocity = velocity.lerp(direction * speed, accel * delta)
			move_and_slide()
		ATACKING:
			pass
			
			
		







		


func _on_attack_range_body_entered(body):
	if(body.has_method("player")):
		state = ATACKING


func _on_attack_range_body_exited(body):
	if(body.has_method("player")):
		state = WALKING
