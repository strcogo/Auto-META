extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var anim = $AnimationPlayer


func _ready() -> void:
	color_rect.visible = false
	anim.animation_finished.connect(_on_animation_finished)


func _on_animation_finished(anim_name) -> void:
	if(anim_name == "fade_to_black"):
		on_transition_finished.emit()
		anim.play("unfade")
	elif(anim_name == "unfade"):
		color_rect.visible = false
	

func transition() -> void:
	color_rect.visible = true
	anim.play("fade_to_black")
