extends Node3D

@onready var animation_player = $AnimationPlayer as AnimationPlayer

var _in_area = false
var _in_range_pickup = null
var next_weapon = null
var current_weapon = null
var weapon_list = {}

@export var _weapon_resources: Array[WeaponResource]

func _ready():
	Initialize()

func _physics_process(delta):
	if(_in_area && Input.is_action_just_pressed("interact")):
		changeWeapon(next_weapon)

func Initialize():
	for weapon in _weapon_resources:
		weapon_list[weapon.weapon_name] = weapon

func changeWeapon(weapon_name: String):
	if(current_weapon != null):
		animation_player.play(current_weapon.deactivate_anim)
	_in_range_pickup.queue_free()
	current_weapon = weapon_list[weapon_name]
	animation_player.play(current_weapon.activate_anim)
	




func _on_pickup_area_body_entered(body):
	_in_area = true
	next_weapon = body.weapon_name
	_in_range_pickup = body

func _on_pickup_area_body_exited(body):
	_in_area = false
	next_weapon = null
