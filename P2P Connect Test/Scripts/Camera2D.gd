extends Camera2D


var zoom_calc = 1
var current_zoom = get_zoom()
const ZOOM_SPEED = 5

func _process(delta):
	if (Input.is_action_just_released("scroll_down")):
		zoom_calc += 0.25
		zoom_calc = min(zoom_calc, 1.5)

	if (Input.is_action_just_released("scroll_up")):
		zoom_calc -= 0.25
		zoom_calc = max(zoom_calc, 0.25)

	if (current_zoom != Vector2(zoom_calc, zoom_calc)):
		current_zoom = lerp(get_zoom(), Vector2(zoom_calc, zoom_calc), ZOOM_SPEED * delta)
		set_zoom(current_zoom)

	if (Input.is_action_just_released("left_click")):
		var mouse_pos = get_global_mouse_position()
		var index_map = get_tree().get_root().get_node("MainScene/"+ get_tree().get_root().get_node("MainScene").mapnode).world_to_map(mouse_pos)
		set_position(get_tree().get_root().get_node("MainScene/"+ get_tree().get_root().get_node("MainScene").mapnode).map_to_world(index_map)+Vector2(32,32))

	if (Input.is_action_just_released("2_test_camera")): #Can also put in MainScene and $Player
		set_position(get_parent().get_node("Player").get_position()) 


#func set_position( Vector2(,) ) is inherited 



