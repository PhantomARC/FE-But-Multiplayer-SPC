extends Node2D


var turn_end = null
var select_map = null
var player_instance = load("res://Actors/Player.tscn").instance()
var player_instance2 = load("res://Actors/Player.tscn").instance()
var num_players = 2
var player_position_pixel = null #Vector2, use onready in future
var player_position_tile_map = null #Vector2, use onready 
var current_tile_type_int = null #onready
var step_count_limit = 3
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
	#player_instance.set_network_master(get_tree().get_network_unique_id())
	player_instance.is_on_blue_team = true
	add_child(player_instance)
	
	player_instance2.name = (str(Global.other_id))
	player_instance2.set_network_master(Global.other_id)
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
			mouse_pos = global_position_to_tilemap_pos(get_global_mouse_position())
			if (player_select_movement_state == true) and (player_can_move_to_cell(mouse_pos)): #When Player is selecting tile to move
				player_instance.set_position($ShadingOverlay.map_to_world(Vector2(mouse_pos.x, mouse_pos.y)) + Vector2(32, 32)) #Set player pos
				player_select_movement_state = false
				#$Camera2D.set_position($ShadingOverlay.map_to_world(Vector2(mouse_pos.x, mouse_pos.y)) + Vector2(32, 32)) #Sets camera to player location
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
				#$Camera2D.set_position($ShadingOverlay.map_to_world(Vector2(mouse_pos.x, mouse_pos.y)) + Vector2(32, 32)) #Sets camera to player location
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


var step_counter = 0
var path = []
var mouse_pos = Vector2()
var path_display = [] #Blue line path
var path_display_inverted = []
var reached_end = false
var player_pos = Vector2()

const DISPLAY_RATE = 0.01
const PATH_DISPLAY_RATE = 0.1
const MAX_ITERS = 10000
var queue = []
var visited = {}
var visited_data_for_display = [] 
var tiles_player_can_walk_to = []

func _draw(): 	#Draws circles, rectangles, lines, and sets ShadingOverlay cell types
	for cell_info in visited_data_for_display:
		var cell_pos = $ShadingOverlay.map_to_world(Vector2(cell_info.pos.x, cell_info.pos.y)) + Vector2(32, 32)
		if reached_end:
			draw_circle(cell_pos,15,Color.lightsalmon)
		else:
			$ShadingOverlay.set_cellv(Vector2(cell_info.pos.x, cell_info.pos.y), 0)
		if cell_info.last_pos != null:
			var last_cell_pos = $ShadingOverlay.map_to_world(Vector2(cell_info.last_pos.x, cell_info.last_pos.y)) + Vector2(32, 32)
			if reached_end:
				draw_line(cell_pos, last_cell_pos, Color.lightgreen, 2)
				$ShadingOverlay.set_cellv(Vector2(cell_info.pos.x, cell_info.pos.y), 0)
			else:
				draw_line(cell_pos, last_cell_pos, Color.green, 2)
				$ShadingOverlay.set_cellv(Vector2(cell_info.pos.x, cell_info.pos.y), 0)
	draw_circle($ShadingOverlay.map_to_world(Vector2(mouse_pos.x, mouse_pos.y)) + Vector2(32, 32), 15, Color.yellow)
	var last_cell_pos = null
	if len(path_display) > 0:
		last_cell_pos = $ShadingOverlay.map_to_world(Vector2(path_display[0].x, path_display[0].y)) + Vector2(32, 32)
	for cell in path_display:
		var cell_pos = $ShadingOverlay.map_to_world(Vector2(cell.x, cell.y)) + Vector2(32, 32)
		draw_line(cell_pos, last_cell_pos, Color.blue, 2)
		last_cell_pos = cell_pos


func player_can_move_to_cell(cell_pos): #Returns true if the targeted cell is inside the flood pathfinding, or if the player can walk to the targetted cell
	for visited_cell in visited_data_for_display :
		if (cell_pos.x == visited_cell.pos.x) and (cell_pos.y == visited_cell.pos.y) and (visited_cell.step_counter <=step_count_limit):
			return true
	return false


func global_position_to_tilemap_pos(pos):
	var t_pos = $ShadingOverlay.world_to_map(pos)
	return {"x": int(round(t_pos.x)), "y": int(round(t_pos.y))}


func can_move_to_spot(cell_pos): #returns true if the tile is walkable, must update with new tiles, does not account for step_count
	return ($ShadingOverlay.get_cell(cell_pos.x, cell_pos.y) == -1 or  
			$ShadingOverlay.get_cell(cell_pos.x, cell_pos.y) == 0  )


func get_path_bfs(start_pos, goal_pos, step_counter):
	queue = [{"pos": start_pos, "last_pos": null, "step_counter": step_counter}]
	visited = {}
	visited_data_for_display = []
	path_display = []
	reached_end = false
	update()
	if !can_move_to_spot(goal_pos):
		yield(get_tree().create_timer(DISPLAY_RATE), "timeout") # I don't understand yield but this is required
		return []
	var iters = 0
	while queue.size() > 0:
		var cell_info = queue.pop_front()
		if check_cell(cell_info.pos, cell_info.last_pos, goal_pos, cell_info.step_counter):
			reached_end = true
		iters += 1
		if iters >= MAX_ITERS:
			return []
		yield(get_tree().create_timer(DISPLAY_RATE), "timeout")
		update() #tab for real time processing visualization
	var backtraced_path = []
	var cur_pos = goal_pos
	var _step_counter1 = step_counter
	while str(cur_pos) in visited and visited[str(cur_pos)] != null: #draw blue line
		yield(get_tree().create_timer(PATH_DISPLAY_RATE), "timeout")
		update()
		if cur_pos != null:
			backtraced_path.append(cur_pos)
			path_display.append(cur_pos)
		cur_pos = visited[str(cur_pos)]
	path_display.append(start_pos)
	backtraced_path.invert()
	path_display_inverted = path_display.duplicate()
	path_display_inverted.invert()
	tiles_player_can_walk_to = backtraced_path #blue path tiles are added into tiles_player_can_walk_to
	return backtraced_path


func check_cell(cur_pos, last_pos, _goal_pos,step_counter1):
	if !can_move_to_spot(cur_pos):
		return false
	if str(cur_pos) in visited:
		return false
	visited[str(cur_pos)] = last_pos
	visited_data_for_display.append({"pos": cur_pos, "last_pos": last_pos,"step_counter": step_counter1})
	if step_counter1 == step_count_limit:
		return true
	queue.push_back({"pos": {"x": cur_pos.x, "y": cur_pos.y + 1}, "last_pos": cur_pos, "step_counter": step_counter1 + 1})
	queue.push_back({"pos": {"x": cur_pos.x + 1, "y": cur_pos.y}, "last_pos": cur_pos, "step_counter": step_counter1 + 1})
	queue.push_back({"pos": {"x": cur_pos.x, "y": cur_pos.y - 1}, "last_pos": cur_pos, "step_counter": step_counter1 + 1})
	queue.push_back({"pos": {"x": cur_pos.x - 1, "y": cur_pos.y}, "last_pos": cur_pos, "step_counter": step_counter1 + 1})
	if !can_move_to_spot(cur_pos):
		return false
	if str(cur_pos) in visited:
		return false
