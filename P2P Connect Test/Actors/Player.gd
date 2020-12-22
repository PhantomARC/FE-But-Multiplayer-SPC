extends Area2D

onready var ray = $RayCast2D

onready var tween = $Tween

onready var global_load = get_node("/root/Global")

export var speed = 10

onready var team = global_load.igt_turn

var step_count = 0

var tile_size = 64

var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}

func _ready(): #positions player at center of tile
	position = position.snapped(Vector2.ONE * tile_size) #Snap rounds the position to the nearest tile increment, and adding a half-tile amount makes sure the player is centered on the tile.
	position += Vector2.ONE * tile_size/2

func _unhandled_input(event): #movement
	if tween.is_active():
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir) and global_load.igt_turn == team:
			move(dir)
			step_count+=1
			#print(step_count)

func move(dir): #detect collision
	ray.cast_to = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		 move_tween(dir)

func move_tween(dir):
	tween.interpolate_property(self, "position", position, position + inputs[dir] * tile_size, 1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func get_step_count():
	return step_count

func _process(delta):
	if global_load.igt_turn == team:
		$Camera2D.current = true
	else:
		$Camera2D.current = false





