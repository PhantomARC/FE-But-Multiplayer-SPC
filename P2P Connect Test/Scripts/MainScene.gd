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
var player_select_movement_state = false


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
	if Global.team_turn: 
		if Input.is_action_just_pressed("right_click"): 
			mouse_pos = pathfinding.global_position_to_tilemap_pos(get_global_mouse_position())
			if (player_select_movement_state == true) and (player_can_move_to_cell(mouse_pos)): #When Player is selecting tile to move
				player_instance.set_position($ShadingOverlay.map_to_world(Vector2(mouse_pos.x, mouse_pos.y)) + Vector2(32, 32)) #Set player pos
				player_select_movement_state = false
				$Camera2D.set_position($ShadingOverlay.map_to_world(Vector2(mouse_pos.x, mouse_pos.y)) + Vector2(32, 32)) #Sets camera to player location
				for cell_info in visited_data_for_display: #Deletes all 
					$ShadingOverlay.set_cellv(Vector2(cell_info.pos.x, cell_info.pos.y), -1)
				turn_end = true
			else: #When player is first viewing the flood
				player_pos = global_position_to_tilemap_pos(player_instance.global_position)
				#mouse_pos = global_position_to_tilemap_pos(get_global_mouse_position())
				path = []
				path = yield(get_path_bfs(player_pos, mouse_pos, step_counter), "completed")
				player_select_movement_state = true
				update()
	if !Global.team_turn: 
		if Input.is_action_just_pressed("right_click"): 
			mouse_pos = global_position_to_tilemap_pos(get_global_mouse_position())
			if (player_select_movement_state == true) and (player_can_move_to_cell(mouse_pos)): #When Player is selecting tile to move
				player_instance2.set_position($ShadingOverlay.map_to_world(Vector2(mouse_pos.x, mouse_pos.y)) + Vector2(32, 32)) #Set player pos
				player_select_movement_state = false
				$Camera2D.set_position($ShadingOverlay.map_to_world(Vector2(mouse_pos.x, mouse_pos.y)) + Vector2(32, 32)) #Sets camera to player location
				for cell_info in visited_data_for_display: #Deletes all 
					$ShadingOverlay.set_cellv(Vector2(cell_info.pos.x, cell_info.pos.y), -1)
				turn_end = true
			else: #When player is first viewing the flood
				player_pos = global_position_to_tilemap_pos(player_instance2.global_position)
				#mouse_pos = global_position_to_tilemap_pos(get_global_mouse_position())
				path = []
				path = yield(get_path_bfs(player_pos, mouse_pos, step_counter), "completed")
				player_select_movement_state = true
				update()
	if turn_end: #Switches Global.team_turn to the opposite team once the turn ends, sets turn_end to false
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
