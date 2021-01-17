extends Camera2D


var zoom_calc = 1
var current_zoom = get_zoom()
const ZOOM_SPEED = 5

var alpha_numdic = {
	'a' : 0,'b' : 1,'c' : 2,'d' : 3,
	'e' : 4,'f' : 5,'g' : 6,'h' : 7,
	'i' : 8,'j' : 9,'k' : 10,'l' : 11,
	'm' : 12,'n' : 13,'o' : 14,'p' : 15,
	'q' : 16,'r' : 17,'s' : 18,'t' : 19,
	'u' : 20,'v' : 21,'w' : 22,'x' : 23,
	'y' : 24,'z' : 25,
}


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


func refer_tile(returnfunc):
	#print("Tile called: " + returnfunc)
	var tilecalc = []
	for i in len(returnfunc)-1:
		i = i + 1
		tilecalc.push_back(returnfunc[i])
	if not tilecalc[1] in alpha_numdic:
		tilecalc.push_front("a")
	if not tilecalc.size() == 4:
		tilecalc.insert(2,"0")
	var reference = Vector2(alpha_numdic[tilecalc[0]] * 26 + alpha_numdic[tilecalc[1]],
			(int(tilecalc[2]) * 10 + int(tilecalc[3])) * -1)
	#print(str(reference))
	set_position(get_tree().get_root().get_node("MainScene/"+ get_tree().get_root().get_node("MainScene").mapnode).map_to_world(reference)+Vector2(32,32))
	
#func set_position( Vector2(,) ) is inherited 



