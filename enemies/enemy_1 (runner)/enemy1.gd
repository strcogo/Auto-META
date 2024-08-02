extends CharacterBody3D

var speed = 2
var accel = 10
@export var life = 400


@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var player = get_parent().get_parent().get_node("Player")

@onready var direction = Vector3()
@onready var animPlayer = $AnimationPlayer

enum {
	WALKING,
	ATACKING,
	STUNNED
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
			if($AttackCooldown.is_stopped()):
				$AnimationPlayer.play("hit")
				$AttackCooldown.start()
		STUNNED:
			animPlayer.play("stunned")

func take_damage(amount: int):
	velocity = (direction * -1) * 30
	move_and_slide()
	life -= amount
	$AnimationPlayer.play("damage")
	if(life <= 0):
		queue_free()


func _on_attack_range_body_entered(body):
	if(body.has_method("player")) and state != STUNNED:
		state = ATACKING


func _on_attack_range_body_exited(body):
	if(body.has_method("player")) and state != STUNNED:
		state = WALKING

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "stunned":
		state = WALKING
	animPlayer.play("reset")
