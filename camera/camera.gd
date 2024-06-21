extends Node3D

# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var resolution = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos)
	camera_movement(resolution, mouse_pos)

func camera_movement(resolution, mouse_pos):
	var res_y = int(resolution[0]/2)
	var res_x = int(resolution[1]/2)
	var y = mouse_pos[0]
	var x = mouse_pos[1]
	var lalau_y
	var lalau_x
	
	if y >= res_y:
		lalau_y = y/res_y
		#self.global_position.x = character.global_position.x
	else: #
		lalau_y = ((y/res_y)*-1+2)*-1
		#self.global_position.x -= 
	if x >= res_x:
		lalau_x = x/res_x
		#print(lalau_x)
	else:
		lalau_x = (x/res_x + 1)*-1
		#print(lalau_x)


