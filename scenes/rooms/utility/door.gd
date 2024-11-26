extends StaticBody3D

@onready var porta: MeshInstance3D = $porta
@onready var colisao_porta: CollisionShape3D = $DoorCollision
@onready var trava: MeshInstance3D = $trava
@onready var anim: AnimationPlayer = $portas/AnimationPlayer


func _ready() -> void:
	colisao_porta.disabled = true


func set_progress(value: float) -> void:
	porta.material_override.set_shader_parameter("Progress", value)


func open():
	anim.play("travaAction")
	await anim.animation_finished
	trava.queue_free()
	var tween = create_tween()
	tween.tween_method(set_progress, -3.0, 1.0, 2)
	await tween.finished
	colisao_porta.set_deferred("disabled", true)	
	porta.queue_free()


func close():
	colisao_porta.set_deferred("disabled", false)
	var tween = create_tween()
	tween.tween_method(set_progress, 1.0, -3.0, 2)
	await tween.finished
	trava.visible = true
	
