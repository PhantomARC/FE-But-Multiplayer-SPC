extends Node2D

var select_map = null
var player_load = load("res://Actors/Player.tscn")
var player_instance = player_load.instance()
var player_position_pixel = null #Vector2
var player_position_tile_map = null #Vector2

var current_tile_type_int = null

onready var global_load = get_node("/root/Global")

func go_to_red_team_end_screen():
	get_tree().change_scene("res://Scenes/RedTeamEndScreen.tscn")


func go_to_blue_team_end_screen():
	get_tree().change_scene("res://Scenes/BlueTeamEndScreen.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	if global_load.map_select == 1:
		select_map = load("res://Maps/MapVolcano.tscn")
		
	elif global_load.map_select == 2:
		select_map = load("res://Maps/MapPlains.tscn")
		
	
	add_child(select_map.instance())
	
	global_load.igt_turn = true
	player_instance = player_load.instance()
	add_child(player_instance)
	
	global_load.igt_turn = false
	player_instance = player_load.instance()
	add_child(player_instance)
	#print($Player.get_position()
	#print($"Plains Tilemap".get_cellv($"Plains Tilemap".world_to_map(Vector2(32,32))))
	#print($"Plains Tilemap".get_cellv(Vector2(32,32)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player.get_step_count() == 20: #and is_on_red_team()
		go_to_red_team_end_screen()
	#if $Player.get_step_count() == 10: #and is_on_blue_team()
		#go_to_blue_team_end_screen()
	player_position_pixel = $Player.get_position()  #May need to put setter in another func
	player_position_tile_map = get_player_position_tile_map() #May need to put setter in another func
	current_tile_type_int = get_current_tile_type()


func get_player_position_tile_map(): #Must be updated when adding new maps
	if global_load.map_select == 1:
		return $MapVolcano.world_to_map(player_position_pixel)
	if global_load.map_select == 2:
		return $MapPlains.world_to_map(player_position_pixel)


func get_current_tile_type(): #Must be updated when adding new maps
	if global_load.map_select == 1:
		return $MapVolcano.get_cellv(player_position_tile_map)
	if global_load.map_select == 2:
		return $MapPlains.get_cellv(player_position_tile_map)


func _input(event):
	if(event is InputEventKey):
		print(player_position_pixel)
		print(player_position_tile_map)
		print(current_tile_type_int)


func get_gerard():
		return "gerard"
		
