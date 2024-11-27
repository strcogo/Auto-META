extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var player = get_parent().get_parent().get_node("Player")
@onready var direction = Vector3()
@onready var anim_player = $Pivot/Model/AnimationPlayer
@onready var model: MeshInstance3D = $Pivot/Model

var speed = 2
var accel = 10
var state = CHASING

@export var life = 400

enum {
	CHASING,
	ATTACKING,
	STUNNED
}


func _physics_process(delta: float) -> void:
	nav.target_position = player.position  
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	$Pivot.basis = Basis.looking_at(direction)
	
	match state:
		
		CHASING:
			anim_player.play("idle")

			velocity = velocity.lerp(direction * speed, accel * delta)
			move_and_slide()
			
		ATTACKING:
			if($AttackCooldown.is_stopped()):
				anim_player.play("hit")
				$AttackCooldown.start()
				
		STUNNED:
			anim_player.play("stunned")


func take_damage(amount: int) -> void:
	MusicPlayer.play_FX(load("res://audio/FX/hit.mp3"))
	player.get_node("CameraPivot/Camera").add_duration(amount / 10)
	Hitstop.hit_stop(amount / 10)
	velocity = (direction * -1) * 30
	move_and_slide()
	life -= amount
	if(life <= 0):
		MusicPlayer.play_FX(load("res://audio/FX/enemy_death.mp3"))
		queue_free()


func _on_attack_range_body_entered(body: CharacterBody3D) -> void:
	if(body.has_method("player") and state != STUNNED):
		state = ATTACKING


func _on_attack_range_body_exited(body: CharacterBody3D) -> void:
	if(body.has_method("player") and state != STUNNED):
		await anim_player.animation_finished
		state = CHASING


func _on_animation_player_animation_finished(anim_name: String) -> void:
	if(anim_name == "stunned"):
		state = CHASING
	anim_player.play("reset")
