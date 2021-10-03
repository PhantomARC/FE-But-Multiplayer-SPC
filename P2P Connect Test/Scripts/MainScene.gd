extends Node2D


var turn_end = null
var select_map = null
var player_instance = load("res://Actors/Player.tscn").instance()
var player_instance2 = load("res://Actors/Player.tscn").instance()
var num_players = 2
var player_position_pixel = null #Vector2, use onready in future
var player_position_tile_map = null #Vector2, use onready 
var current_tile_type_int = null #onready
#var step_count_limit = 3
var mouse_pos = Vector2()

func go_to_end_screen(result):
	get_tree().change_scene(result)
	queue_free()


func _ready():
	select_map = load("res://Maps/" + Global.dict_maps[Global.map_num] + ".tscn")
	$AudioStreamPlayer.stream = load(Global.dict_map_music[Global.map_num])
	$AudioStreamPlayer.playing = true
	
	add_child(select_map.instance())
	add_child(load("res://Maps/ShadingOverlay.tscn").instance())
	
	player_instance.name = "Player" 
	player_instance.is_on_blue_team = true
	add_child(player_instance)
	
	player_instance2.name = (str(Global.other_id))
	player_instance.is_on_red_team = true
	player_instance2.modulate = Color(1.0, 0.0, 0.0, 1.0)
	add_child(player_instance2)
	player_instance2.set_position($ShadingOverlay.map_to_world(Vector2(1,1)) + Vector2(32, 32))
	Global.team_turn = true
	add_child(load("res://Scenes/Camera2D.tscn").instance())
	add_child(load("res://Scenes/TestUI.tscn").instance())


func _process(_delta):
	player_position_pixel = $Player.get_position()  #May need to put setter in another func
	player_position_tile_map = get_player_position_tile_map() #May need to put setter in another func
	current_tile_type_int = get_current_tile_type()
	if Global.team_turn: #Blue team turn
		if Input.is_action_just_pressed("right_click"): 
			player_instance.player_move_process() #Entire process of flood fill and movement
	if !Global.team_turn:  #Red team turn
		if Input.is_action_just_pressed("right_click"): 
			player_instance2.player_move_process()
	if turn_end: #Switches Global.team_turn to the opposite team once the turn ends, sets turn_end to false #turn_end set in player object, should update in future once better definition of turn_end is done
		var current_team = null
		turn_end = false
		Global.team_turn = !Global.team_turn
		if Global.team_turn: 
			current_team = "BLUE"
		else: 
			current_team = "RED"
		$Control/CanvasLayer/Panel/"REGEX SEND".send_message(current_team + " team's turn")


func get_player_position_tile_map():
	var map_name = get_node(Global.dict_maps[Global.map_num])
	return map_name.world_to_map(player_position_pixel)


func get_current_tile_type():
	var map_name = get_node(Global.dict_maps[Global.map_num])
	return map_name.get_cellv(player_position_tile_map)


func get_num_players():
	return num_players


func set_num_players(num):
	num_players = num
