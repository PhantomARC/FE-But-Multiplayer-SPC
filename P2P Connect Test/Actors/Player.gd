extends Area2D

onready var ray = $RayCast2D
onready var tween = $Tween
export var speed = 10
var team = Global.team_turn #true = blue, false = red
var id : int 
var step_count = 0
var tile_size = 64
var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN,
}
var is_on_red_team = null
var is_on_blue_team = null


func _ready(): #positions player at center of tile
	position = position.snapped(Vector2.ONE * tile_size) 
	#Snap rounds the position to the nearest tile increment, and 
	#adding a half-tile amount makes sure the player is centered on the tile.
	position += Vector2.ONE * tile_size/2
	Global.other_id = Global.other_id + 1
	


func _unhandled_input(event): #movement
	if tween.is_active():
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir) and Global.team_turn == team:
			move(dir)
			step_count+=1


func move(dir): #detect collision
	ray.cast_to = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		 move_tween(dir)


func move_tween(dir):
	tween.interpolate_property(self, "position", position, position \
			+ inputs[dir] * tile_size, 1.0/speed, Tween.TRANS_SINE, 
			Tween.EASE_IN_OUT)
	tween.start()


func get_step_count():
	return step_count


func get_id():
	return id


func set_id(sid):
	self.id = sid


func get_position_global():
	return get_position()


func get_team():
	return team




