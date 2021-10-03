extends Area2D


var team : bool = Global.team_turn #true = blue, false = red
var id : int 
var step_count : int = 0
var tile_size : int = 64
var is_on_red_team : bool = false #!deprecate
var is_on_blue_team : bool = false #!deprecate
var step_count_limit = 3
var player_select_movement_state = false
var mouse_pos = Vector2()
var player_pos = Vector2()
var position_minus = Vector2() #Since ShadingOverlay is attached to player, tiles will be offset, variable position_minus un-offsets these values by minusing the previous player location from the new player location

func _ready(): #place player at tile center
	Global.other_id = Global.other_id + 1
	position = position.snapped(Vector2.ONE * Global.TILE_SIZE) + Vector2.ONE * Global.TILE_SIZE/2
	#Snap rounds position to the nearest tile integer
	#Add a half-tile amount to center player.


func get_step_count() -> int:
	return step_count


func get_id() -> int:
	return id


func set_id(sid) -> void:
	self.id = sid


func get_position_global() -> Vector2:
	return get_position()


func get_team():
	return team


func player_move_process(): #The entire process of flood pathfinding and moving to the player selected tile
	#mouse_pos = get_parent().mouse_pos
	mouse_pos = self.get_node("Pathfinding").global_position_to_tilemap_pos(get_global_mouse_position())
	if (player_select_movement_state == true) and ($Pathfinding.player_can_move_to_cell(mouse_pos)): #When Player is selecting tile to move
		self.set_position($ShadingOverlay.map_to_world(Vector2(mouse_pos.x, mouse_pos.y)) + Vector2(32, 32)) #Set player pos
		
		player_select_movement_state = false
		get_parent().get_node("Camera2D").set_position($ShadingOverlay.map_to_world(Vector2(mouse_pos.x, mouse_pos.y)) + Vector2(32, 32)) #Sets camera to player location
		for cell_info in $Pathfinding.visited_data_for_display: #Deletes all 
			$ShadingOverlay.set_cellv(Vector2(cell_info.pos.x, cell_info.pos.y) - position_minus , -1)
		position_minus = Vector2(mouse_pos.x, mouse_pos.y)
		get_parent().turn_end = true #Update definition in future, put in MainScene
	else: #When player is first viewing the flood
		player_pos = $Pathfinding.global_position_to_tilemap_pos(self.global_position)
		 
		#mouse_pos = global_position_to_tilemap_pos(get_global_mouse_position())
		$Pathfinding.path = []
		$Pathfinding.path = yield($Pathfinding.get_path_bfs(player_pos, mouse_pos, $Pathfinding.step_counter), "completed")
		player_select_movement_state = true
		update()
