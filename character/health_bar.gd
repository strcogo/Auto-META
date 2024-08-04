extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar
@onready var label = $Label

var life = 0 : set = _set_life


func init_health(_health):
	life = _health
	max_value = life
	value = life
	damage_bar.max_value = life
	damage_bar.value = life
	

func _set_life(new_life):
	if(new_life > max_value):
		max_value = new_life
	life = min(max_value, new_life)
	value = life
	label.text = str(value) + "/" + str(max_value)
	timer.start()
	

func _on_timer_timeout():
	var tween = create_tween()
	tween.tween_property(damage_bar, "value", life, 0.3)
