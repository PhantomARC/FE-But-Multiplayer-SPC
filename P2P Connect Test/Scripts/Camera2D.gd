extends Camera2D


var zoom_calc = 1
var current_zoom = get_zoom()
const ZOOM_SPEED = 5
const ASCII = 97
const PATH = "GameScene/Canvas/HSplitContainerMain/VSplitContainerLeft/ViewportContainer/Viewport/MainScene/"

func _process(delta):
	#calculate zoom
	if Input.is_action_just_released("scroll_down"):
		zoom_calc += 0.25
	if Input.is_action_just_released("scroll_up"):
		zoom_calc -= 0.25
	zoom_calc = clamp(zoom_calc,0.25,1.5)
	
	#process zoom
	if current_zoom != Vector2(zoom_calc, zoom_calc):
		current_zoom = lerp(get_zoom(), Vector2(zoom_calc, zoom_calc), 
				ZOOM_SPEED * delta)
		set_zoom(current_zoom)

func _input(_event): #alter map with middle click
	if Input.is_action_just_released("scroll_click"):
		var mouse_pos = get_global_mouse_position()
		var index_loc = get_tree().get_root().get_node(PATH + Global.dict_maps[Global.map_num])
		var index_map = index_loc.world_to_map(mouse_pos)
		set_position(index_loc.map_to_world(index_map) + Vector2(32,32))


func refer_tile(returnfunc) -> void: #fix tile notation if chars < 4
	var tilecalc = []
	for i in range(1,len(returnfunc)):
		tilecalc.push_back(returnfunc[i].to_lower())
	if not ord(tilecalc[1]) in range(ASCII,122):
		tilecalc.push_front('a')
	if not tilecalc.size() == 4:
		tilecalc.insert(2,'0')
	var reference = Vector2(
		(ord(tilecalc[0]) - ASCII) * 26 + (ord(tilecalc[1]) - ASCII),
		(int(tilecalc[2]) * 10 + int(tilecalc[3])) * -1)
	set_position(get_tree().get_root().get_node(PATH \
		+ Global.dict_maps[Global.map_num]).map_to_world(reference) + Vector2(32,32))

