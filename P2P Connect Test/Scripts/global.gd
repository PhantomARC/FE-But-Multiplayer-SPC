extends Node


#in-game
var map_num : int = 1 #default to Map 1 on load
var team_turn : bool = false #true = blue team's turn, false = red team's turn

#online interaction
var other_id_dict : Dictionary = {}
var other_id : int = -1 #multiplayer network base
var playername : String = "" #username as String
var usercolor : int = 2 #user color as integer
var dict_user_relegate : Dictionary = {} #player identities as integers
var dict_user_color : Dictionary = {} #player colors as integers

#map database
var dict_maps : Dictionary = {#map graphs
	0 : "MapVolcano",
	1 : "MapPlains",
	2 : "MapCrazyHamburger",
}
var dict_map_music : Dictionary = {#map soundtracks
	0 : "res://Assets/Sounds/Firefight Tension.wav",
	1 : "res://Assets/Sounds/Windlands.wav",
	2 : "res://Assets/Sounds/Windlands.wav",
}

#standard data
var maxInt : int = 9223372036854775807
const tileSize : int = 64



func set_map_num(call_num) -> void: #when called, change map
	map_num = call_num


func _input(_event): #trigger when any key is pressed
	if Input.is_action_just_pressed("fullscreen_toggle"): #trigger fullscreen
		OS.window_fullscreen = !OS.window_fullscreen


func dict_user_relegate_clear() -> void: #trigger when leaving a lobby, clears dicts
	dict_user_relegate = {}
	dict_user_color = {}


func register(data) -> void:
	get_tree().call_group("log", "relay", data)


""" Notes
* group "multiplayer" is applied to all elements by lobby.gd
* group "bgm_vol" and "sfx_vol" handle their respecitve sound element volumes
* to make a group do something, use: `get_tree().call_group("a", "function")`
	this includes inherent functions like `queue_free()`
* to add to a group (even if nonexistent), use: `add_to_group("a")`
	this can be tied to children, e.g.: `$Child.add_to_group("a")`
* MapSelectScene.gd <> btn array must be updated whenever a new map is added.

"""

""" To Do List
* Tackle MainScene.gd D:<
* Implement dictionary sending multiplayer
* Implement adding more players than just 2!
"""
