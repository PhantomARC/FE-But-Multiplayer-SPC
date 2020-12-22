extends Node


var other_id = -1 #default other player IDs' to -1
var map_select = 1 #default to Map 1 on load
var igt_turn = true #true = blue, false = red
var volume = -80

func set_map_select(map_select_number): #when called, change map
	map_select = map_select_number


func _ready():
	pass


func _input(event): #trigger when any key is pressed
	if (Input.is_action_just_pressed("ui_select")):
		if igt_turn == true:
			igt_turn = false
		elif igt_turn == false:
			igt_turn = true
