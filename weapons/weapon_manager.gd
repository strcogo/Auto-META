extends Node3D

@onready var anim_player = $AnimationPlayer as AnimationPlayer
@onready var weapons_node = get_node("../../..").get_node("Weapons")

var _in_area = false
var _in_range_pickup = null
var next_weapon = null
var current_weapon = null
var weapon_list = {}

@export var _weapon_resources: Array[WeaponResource]


func _ready():
	initialize()


func _physics_process(delta):
	if(_in_area && Input.is_action_just_pressed("interact")):
		change_weapon(next_weapon)
	play_attack()


func initialize():
	for weapon in _weapon_resources:
		weapon_list[weapon.weapon_name] = weapon
	current_weapon = weapon_list["sword"]
	anim_player.play(current_weapon.activate_anim)
	

func change_weapon(weapon_name: String):
	anim_player.play(current_weapon.deactivate_anim)
	await anim_player.animation_finished
	var dropped_weapon = current_weapon.weapon_drop.instantiate()
	dropped_weapon.position = _in_range_pickup.position
	_in_range_pickup.queue_free()
	weapons_node.add_child(dropped_weapon)
	current_weapon = weapon_list[weapon_name]
	anim_player.play(current_weapon.activate_anim)


func play_attack():
	if Input.is_action_just_pressed("attack"):
		anim_player.play(current_weapon.attack_anim)
		await anim_player.animation_finished


func _on_pickup_area_body_entered(body: CharacterBody3D):
	_in_area = true
	next_weapon = body.weapon_name
	_in_range_pickup = body


func _on_pickup_area_body_exited(body: CharacterBody3D):
	_in_area = false
	next_weapon = null


func _on_animation_player_animation_finished(anim_name: String):
	anim_player.play(current_weapon.idle_anim)
