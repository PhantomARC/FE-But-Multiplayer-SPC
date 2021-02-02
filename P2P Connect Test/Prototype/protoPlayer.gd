extends KinematicBody2D


var speed = 5
var loc =Vector2.ZERO


func _ready():
	pass # Replace with function body.


func _process(_delta):
	loc = Vector2()
	if Input.is_action_pressed("ui_left"):
		loc = Vector2(-5,0) + loc
	if Input.is_action_pressed("ui_right"):
		loc = Vector2(5,0) + loc
	if Input.is_action_pressed("ui_up"):
		loc = Vector2(0,-5) + loc
	if Input.is_action_pressed("ui_down"):
		loc = Vector2(0,5) + loc
	
	if loc != Vector2():
		if is_network_master():
			move_and_collide(loc)
		rpc_unreliable("_set_pos",global_transform.origin)

remote func _set_pos(pos):
	global_transform.origin = pos
