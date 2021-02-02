extends Control


var regex_key = {
	"bracketChar" : "\\[|\\]|\\r\\n|\\r|\\n",
	"chessNotation" : "(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})[- .,?!/&+()]|" \
	+ "(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})$",
	}

onready var chat_input_label = $CanvasLayer/containerScreen/ \
		textureBackPanel/textureInputPanel/textInput
onready var chat_display = $CanvasLayer/containerScreen/ \
		textureBackPanel/textureChatPanel/richtextChat
onready var chat_input = $CanvasLayer/containerScreen/ \
		textureBackPanel/textureInputPanel/textInput


func _ready():
	get_tree().connect("connected_to_server", self, "_self_connected")
	get_tree().connect("network_peer_disconnected", self, "_user_disconnected")
	get_tree().connect("network_peer_connected", self, "_user_connected")
	chat_input.connect("text_changed",self,"_on_textInput_text_changed")
	chat_input.connect("focus_entered",self,"_on_textInput_focus_entered")
	chat_input.connect("focus_exited",self,"_on_textInput_focus_exited")
	
	chat_input.set_text("Type Message Here...")
	chat_input.set("custom_colors/font_color", Color(0.88,0.88,0.88,1))


func _input(event):
	if event is InputEventKey && event.pressed:
		if event.scancode == KEY_ENTER:
			if chat_input.has_focus():
				if chat_input.text != "":
					send_message()
				else:
					chat_input.release_focus()
			else:
				chat_input.grab_focus()
			get_tree().set_input_as_handled()
		if event.scancode == KEY_ESCAPE:
			if chat_input.has_focus():
				chat_input.release_focus()


func send_message():
	var message = get_constructed_msg(chat_input)
	chat_input.set_text("")
	var id = get_tree().get_network_unique_id()
	rpc("receive_message", id, message)


sync func receive_message(id, message):
	chat_display.bbcode_text +="[color=" + Global.dict_user_color[id] + "]" \
			+ Global.dict_user_relegate[id] + ": [/color][color=#808080]" \
			+ message + "[/color]\n"


func _on_textInput_text_changed():
	scan_illegal_chars(chat_input)
	chat_input.cursor_set_line(0,true)
	chat_input.cursor_set_column(len(chat_input.get_line(0)),true)


func _on_textInput_focus_entered():
	chat_input.set("custom_colors/font_color", Color("#595959"))
	if chat_input.text == "Type Message Here...":
		chat_input.set_text("")


func _on_textInput_focus_exited():
	chat_input.set("custom_colors/font_color", Color(0.88,0.88,0.88,1))
	if chat_input.text == "":
		chat_input.set_text("Type Message Here...")


func _user_disconnected(id):
	chat_display.bbcode_text += "[color=" + Global.dict_user_color[id] + "]" \
			+ Global.dict_user_relegate[id] \
			+ "[/color][color=#808080] left the lobby.[/color]\n"


sync func add_user(id, regname, color):
	Global.dict_user_relegate[id] = regname
	Global.dict_user_color[id] = Aesthetics.color_code[color]


func _self_connected():
	rpc("ask_all_users")
	rpc("announce_join",get_tree().get_network_unique_id())


sync func ask_all_users():
	var id = get_tree().get_network_unique_id()
	rpc("add_user",id, Global.playername, Global.usercolor)


sync func announce_join(sid):
	chat_display.bbcode_text += "[color=" + Global.dict_user_color[sid] + "]" \
			+ Global.dict_user_relegate[sid] \
			+ "[/color][color=#808080] joined the lobby.[/color]\n"


func scan_illegal_chars(nodePath) -> void:
	var regex = RegEx.new()
	var reg_cleanup = []
	var message = nodePath.text
	regex.compile(regex_key["bracketChar"])
	for result in regex.search_all(nodePath.text):
		reg_cleanup.push_back(result.get_start())
	reg_cleanup.invert()
	for i in range(0, reg_cleanup.size()):
		message.erase(reg_cleanup[i],1)
	nodePath.set_text(message)


func get_constructed_msg(nodePath) -> String:
	var regex = RegEx.new()
	regex.compile(regex_key["chessNotation"])
	var send_queue = nodePath.text
	var insert_order = []
	var metatag = []
	for result in regex.search_all(send_queue):
		metatag.push_back(result.get_string("tile"))
		insert_order.push_back(result.get_start())
		if send_queue[result.get_end()-1] \
				in ['-',' ','.',',','?','!','/','&','+','(',')']:
			insert_order.push_back(result.get_end() - 1)
		else:
			insert_order.push_back(result.get_end())
	metatag.invert()
	insert_order.invert()
	var i :int = 0
	while i < insert_order.size():
		send_queue = send_queue.insert(insert_order[i],"[/url][/color]")
		send_queue = send_queue.insert(insert_order[i + 1],
				"[color=#ff0000][url=" + metatag[(i) / 2] + "]")
		i += 2
	return(send_queue)


func _user_connected(id):
	Global.other_id = id
	var game = preload("res://Prototype/protoGame.tscn").instance()
	get_tree().get_root().add_child(game)
