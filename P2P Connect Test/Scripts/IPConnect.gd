extends Control

var player_info = { }



#remote func register_player(info):
#	# Get the id of the RPC sender.
#	var id = get_tree().get_rpc_sender_id()
#	# Store the info
#	player_info[id] = info


func _user_connected(id):
	Global.other_id = id
	Global.other_id_dict[id] = id
	#rpc_id(id, "register_player", my_info)
	if Global.other_id_dict.size() == 2: #Need to load the game when all players are connected
		var game = preload("res://Prototype/protoGame.tscn").instance()
		get_tree().get_root().add_child(game)
	
	#pre_configure_game()


remote func pre_configure_game():
	var selfPeerID = get_tree().get_network_unique_id()
	#Load World
	var world = load("res://Prototype/protoGame.tscn").instance()
	get_node("/root").add_child(world)
	
	#Load my player
	var my_player = preload("res://Prototype/protoPlayer.tscn").instance()
	my_player.set_name(str(selfPeerID))
	my_player.set_network_master(selfPeerID) # Will be explained later
	my_player.position = Vector2(20,20)
	get_node("/root/Node2D").add_child(my_player)
	
	for p in player_info:
		var player = preload("res://Prototype/protoPlayer.tscn").instance()
		player.set_name(str(p))
		player.set_network_master(p) # Will be explained later
		player.position = Vector2(100,100)
		get_node("/root/Node2D").add_child(player)
		
		rpc_id(1, "done_preconfiguring")

	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring.
	# The server can call get_tree().get_rpc_sender_id() to find out who said they were done.





var regex_key = {
	"bracketChar" : "\\[|\\]|\\r\\n|\\r|\\n",
	"chessNotation" : "(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})[- .,?!/&+()]|(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})$",
	}

onready var chat_display = $CanvasLayer/containerScreen/textureBackPanel/textureChatPanel/richtextChat
onready var chat_input = $CanvasLayer/containerScreen/textureBackPanel/textureInputPanel/textInput


func _ready():
	get_tree().connect("connected_to_server", self, "_self_connected")
	get_tree().connect("network_peer_disconnected", self, "_user_disconnected")
	get_tree().connect("network_peer_connected", self, "_user_connected")
	chat_input.connect("text_changed",self,"_on_textInput_text_changed")
	chat_input.connect("focus_entered",self,"_on_textInput_focus_entered")
	chat_input.connect("focus_exited",self,"_on_textInput_focus_exited")
	
	chat_input.set_text("Type Message Here...")
	chat_input.set("custom_colors/font_color", Color(0.88,0.88,0.88,1))


func _input(event): #trigger send message
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
	parse_message(Global.dict_user_color[id], Global.dict_user_relegate[id], " left the lobby.")


sync func add_user(id, regname, color):
	Global.dict_user_relegate[id] = regname  #May have accidently changed variable here, sorry roy uwu
	Global.dict_user_relegate[id] = Aesthetics.color_code[color]


func _self_connected():
	rpc("ask_all_users")
	rpc("announce_join",get_tree().get_network_unique_id())


sync func ask_all_users():
	var id = get_tree().get_network_unique_id()
	rpc("add_user",id, Global.playername, Global.usercolor)


sync func announce_join(id):
	parse_message(Global.dict_user_color[id], Global.dict_user_relegate[id], " joined the lobby.")


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
		if send_queue[result.get_end()-1] in ['-',' ','.',',','?','!','/','&','+','(',')']:
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





func parse_message(color, id_name, message):
	chat_display.bbcode_text += "[color=" + color + "]" + id_name \
		+ "[/color][color=#808080]" + message + "[/color]\n"
