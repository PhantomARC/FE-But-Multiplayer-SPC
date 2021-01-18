extends Node


#in-game
var map_select = 1 #default to Map 1 on load
var igt_turn = true #true = blue, false = red

#aesthetics (to be moved to files)
var volume = -80
var sfxvol = -60
var transparency = 0.5

#online interaction
var other_id = -1 #default other player IDs' to -1
var playername = null 
var usercolor = 2
var dict_user_relegate = {}
var dict_user_color = {}

#screendata
var screensize = Vector2(960,540)


func _ready():
	if Preferences.is_file_there():
		volume = Preferences.load_val()
		#print("File exists.")
	else:
		#print("File does not exist.")
		pass


func _process(_delta):
	Preferences.save_val(volume)


func set_map_select(map_select_number): #when called, change map
	map_select = map_select_number


func _input(_event): #trigger when any key is pressed
	if (Input.is_action_just_pressed("ui_accept")):
		igt_turn = !igt_turn
	if (Input.is_action_just_pressed("fullscreen_toggle")):
		OS.window_fullscreen = !OS.window_fullscreen


func dict_user_relegate_clear():
	dict_user_relegate = {}
	dict_user_color = {}
