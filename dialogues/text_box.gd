extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var textbox_container = $TextBoxContainer
@onready var end_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextBoxContainer/MarginContainer/HBoxContainer/Label

enum state {
	READY,
	READING,
	FINISHED
}

var current_state = state.READY
var tween = create_tween()
var text_queue = []

func _ready() -> void:
	hide_textbox()
	queue_text("Este texto será escrito na tela!")

	
func _process(delta: float) -> void:
	match current_state:
		state.READY:
			label.visible_ratio = 0.0
			if(!text_queue.is_empty()):
				display_text()
		state.READING:
			if(Input.is_action_just_pressed("ui_accept")):
				label.visible_ratio = 1.0
				tween.stop()
				end_symbol.text = "v"
				current_state = state.FINISHED
		state.FINISHED:
			if(Input.is_action_just_pressed("ui_accept")):
				current_state = state.READY
				hide_textbox()
	

func hide_textbox() -> void:
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()
	

func show_textbox() -> void:
	textbox_container.show()
	
	
func queue_text(new_text: String) -> void:
	text_queue.push_back(new_text)
	

func display_text() -> void:
	var next_text = text_queue.pop_front()
	label.text = next_text
	show_textbox()
	current_state = state.READING
	tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE)
	tween.connect("finished", self.on_tween_finished)


func on_tween_finished() -> void:
	end_symbol.text = "v"
	current_state = state.FINISHED
