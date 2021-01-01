extends Node


#in-game
var other_id = -1 #default other player IDs' to -1
var map_select = 1 #default to Map 1 on load
var igt_turn = true #true = blue, false = red

#aesthetics (to be moved to files)
var volume = -80
var sfxvol = -60
var transparency = 0.5

#online interaction
var playername = null

#screendata
var screensize = Vector2(960,540)


func set_map_select(map_select_number): #when called, change map
	map_select = map_select_number


func _ready():
	pass



func _input(event): #trigger when any key is pressed
	if (Input.is_action_pressed("ui_accept")):
		if igt_turn == true:
			igt_turn = false
		elif igt_turn == false:
			igt_turn = true
