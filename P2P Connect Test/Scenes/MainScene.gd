extends Node2D

var select_map = null
var player_load = load("res://Actors/Player.tscn")
var player_instance = player_load.instance()

var player_position_pixel = null #Vector2, use onready in future
var player_position_tile_map = null #Vector2, use onready 
var current_tile_type_int = null #onready
onready var global_load = get_node("/root/Global")


#Pathfinding
onready var tilemap = $TileMap
onready var player = $Player
onready var step_count_limit = 5
#Pathfinding end

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
	elif global_load.map_select == 3:
		select_map = load("res://Maps/MapCrazyHamburger.tscn")

	
	add_child(select_map.instance())
	add_child(load("res://Maps/ShadingOverlay.tscn").instance())
	
	
	global_load.igt_turn = true
	player_instance = player_load.instance()
	add_child(player_instance)
	
	global_load.igt_turn = false
	#player_instance = player_load.instance()
	#add_child(player_instance)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player.get_step_count() == 20: #and is_on_red_team()
		go_to_red_team_end_screen()
	#if $Player.get_step_count() == 10: #and is_on_blue_team()
		#go_to_blue_team_end_screen()
	player_position_pixel = $Player.get_position()  #May need to put setter in another func
	player_position_tile_map = get_player_position_tile_map() #May need to put setter in another func
	current_tile_type_int = get_current_tile_type()
	
	
	#Pathfinding
	if Input.is_action_just_pressed("click"):
		mouse_pos = global_position_to_tilemap_pos(get_global_mouse_position())
		player_pos = global_position_to_tilemap_pos(player_instance.global_position)
		path = []
		path = yield(get_path_bfs(player_pos, mouse_pos, step_counter), "completed")
		#path = get_path_bfs(player_pos, mouse_pos)
		update()
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	#PathfindingEnd

#Pathfinding
var step_counter = 0
var path = []
var mouse_pos = Vector2()
var path_display = []
var reached_end = false
var player_pos = Vector2()

const DISPLAY_RATE = 0.01
const PATH_DISPLAY_RATE = 0.1
const MAX_ITERS = 10000
var queue = []
var visited = {}
var visited_data_for_display = []
func _draw(): 	
	
	for cell_info in visited_data_for_display:
		var cell_pos = $ShadingOverlay.map_to_world(Vector2(cell_info.pos.x, cell_info.pos.y)) + Vector2(32, 32)
		if reached_end:
			#draw_rect(Rect2(cell_pos - Vector2(8,8),Vector2(15,15)), Color.lightsalmon)
			draw_circle(cell_pos,15,Color.lightsalmon)
			
		else:
			#draw_rect(Rect2(cell_pos - Vector2(32,32),Vector2(64,64)), Color.lightsalmon)
			#draw_circle(cell_pos, 15, Color.red)
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
#	var t_path = path.duplicate()
#	t_path.invert()
	for cell in path_display:
		var cell_pos = $ShadingOverlay.map_to_world(Vector2(cell.x, cell.y)) + Vector2(32, 32)
		draw_rect(Rect2(cell_pos - Vector2(32, 32), Vector2(64,64)), Color.blue)
		draw_line(cell_pos, last_cell_pos, Color.blue, 2)
		last_cell_pos = cell_pos


func global_position_to_tilemap_pos(pos):
	var t_pos = $ShadingOverlay.world_to_map(pos)
	return {"x": int(round(t_pos.x)), "y": int(round(t_pos.y))}


func can_move_to_spot(cell_pos):
	
	var step_count = abs(cell_pos.x - player_pos.x) + abs(cell_pos.y - player_pos.y)
	
	
	print("get cell:", $ShadingOverlay.get_cell(cell_pos.x, cell_pos.y))
	#returns true if the tile is walkable, must update with new tiles
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
	var step_counter1 = step_counter
	while str(cur_pos) in visited and visited[str(cur_pos)] != null: #draw blue line
		yield(get_tree().create_timer(PATH_DISPLAY_RATE), "timeout")
		update()
		if cur_pos != null:
			backtraced_path.append(cur_pos)
			path_display.append(cur_pos)
		cur_pos = visited[str(cur_pos)]
	path_display.append(start_pos)
	backtraced_path.invert()
	return backtraced_path


func check_cell(cur_pos, last_pos, goal_pos,step_counter1):
	if !can_move_to_spot(cur_pos):
		return false
	if str(cur_pos) in visited:
		return false
	print ("step counter:", step_counter1)
	
	
	visited[str(cur_pos)] = last_pos
	visited_data_for_display.append({"pos": cur_pos, "last_pos": last_pos,"step_counter": step_counter1})
	#if cur_pos.x == goal_pos.x and cur_pos.y == goal_pos.y: #stops checking tiles once it checks goal tile
		#return true
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
	print ("step counter", step_counter1)


#Pathfinding End






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

