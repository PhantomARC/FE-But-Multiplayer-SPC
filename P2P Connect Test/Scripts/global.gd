extends Node


var other_id = -1 #default other player IDs' to -1
var map_select = 1 #default to Map 1 on load


func set_map_select(map_select_number): #when called, change map
	map_select = map_select_number


func _ready():
	pass
