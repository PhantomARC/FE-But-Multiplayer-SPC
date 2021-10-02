extends Area2D


var team : bool = Global.team_turn #true = blue, false = red
var id : int 
var step_count : int = 0
var tile_size : int = 64
var is_on_red_team : bool = false #!deprecate
var is_on_blue_team : bool = false #!deprecate
var step_count_limit = 3

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
