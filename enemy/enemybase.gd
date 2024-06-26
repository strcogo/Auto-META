extends CharacterBody3D

var speed = 2
var accel = 10
var life = 100

@onready var player = get_node("../..").get_node("Player")
@onready var nav: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta):
	_chase(delta)

func take_damage(amount: int):
	life -= amount
	if(life <= 0):
		self.queue_free()

func _chase(delta):
	var direction = Vector3()
	nav.target_position = player.position 
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accel * delta)
	move_and_slide()
