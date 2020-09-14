extends Camera2D

var zoom_states = [Vector2(1.5,1.5),Vector2(1.25,1.25),Vector2(1,1),Vector2(0.75,0.75),Vector2(0.5,0.5),Vector2(0.25,0.25)]
var current_zoom = get_zoom()
var zoom_main = 2
const ZOOM_SPEED = 5



func _ready():
	pass

func _process(delta):
	if (Input.is_action_just_released("scroll_up")):
		zoom_main += 1
		zoom_main = min(zoom_main, 5)

	if (Input.is_action_just_released("scroll_down")):
		zoom_main -= 1
		zoom_main = max(zoom_main, 0)
	
	if (current_zoom != zoom_states[zoom_main]):
		current_zoom = lerp(get_zoom(), zoom_states[zoom_main], ZOOM_SPEED * delta)
		set_zoom(current_zoom)
