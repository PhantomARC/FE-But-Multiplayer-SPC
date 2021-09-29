extends Area2D


var team : bool = Global.team_turn #true = blue, false = red
var id : int 
var step_count : int = 0
var tile_size : int = 64
var is_on_red_team : bool = false #!deprecate
var is_on_blue_team : bool = false #!deprecate


func _ready(): #place player at tile center
	Global.other_id = Global.other_id + 1
	position = position.snapped(Vector2.ONE * Global.tileSize) \
			+ Vector2.ONE * Global.tileSize/2
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

#!!! DEPRECATED SCRIPTS BELOW

#onready var tween = $Tween
#var inputs = {
#	"ui_right": Vector2.RIGHT,
#	"ui_left": Vector2.LEFT,
#	"ui_up": Vector2.UP,
#	"ui_down": Vector2.DOWN,
#}

#func _unhandled_input(event): #movement
#	if tween.is_active():
#		return
#	for dir in inputs.keys():
#		if event.is_action_pressed(dir) and Global.team_turn == team:
#			move(dir)
#			step_count+=1


#func move(dir): #detect collision
#	ray.cast_to = inputs[dir] * tile_size
#	ray.force_raycast_update()
#	if !ray.is_colliding():
#		#position += inputs[dir] * tile_size
#		 move_tween(dir)
# onready var ray = $RayCast2D
#export var speed : int = 10

#func move_tween(dir):
#	tween.interpolate_property(self, "position", position, position \
#			+ inputs[dir] * tile_size, 1.0/speed, Tween.TRANS_SINE, 
#			Tween.EASE_IN_OUT)
#	tween.start()
