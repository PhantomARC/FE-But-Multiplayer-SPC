extends Node2D

var port_ID = null
var tcp_ID = null
var host = null
var game = load("res://Scenes/IPConnect.tscn").instance()

onready var ref_user = $CanvasLayer/containerScreen/vboxContainer/hboxUser/lineUser
onready var ref_ipv4 = $CanvasLayer/containerScreen/vboxContainer/hboxIPv4/lineIPv4
onready var ref_port = $CanvasLayer/containerScreen/vboxContainer/hboxPort/linePort


func _ready():
	ref_user.connect("text_changed",self,"_on_lineUser_text_changed")
	ref_ipv4.connect("text_changed",self,"_on_lineIPv4_text_changed")
	ref_port.connect("text_changed",self,"_on_linePort_text_changed")
	$CanvasLayer/containerScreen/vboxContainer/buttonHost.connect("pressed",self,"_on_buttonHost_pressed")
	$CanvasLayer/containerScreen/vboxContainer/buttonJoin.connect("pressed",self,"_on_buttonJoin_pressed")
	$CanvasLayer/buttonBack.connect("pressed",self,"_on_buttonBack_pressed")
	
	add_child(load("res://Scenes/Background.tscn").instance())
	get_tree().get_root().add_child(game)
	ref_port.set_max_length(5)
	
	Global.playername = "User"
	tcp_ID = "25.3.252.29"
	port_ID = int(42069)


func clear_screen():
	$CanvasLayer/containerScreen.hide()
	$CanvasLayer/buttonBack.hide()
	$Background.hide()
	get_tree().get_root().get_node("ChatRoom").show()
	Global.dict_user_relegate[1] = Global.playername
	Global.dict_user_color[1] = get_tree().get_root().get_node("ChatRoom").color_rep[Global.usercolor]


func _on_linePort_text_changed(port_num):
	port_scan_illegal_chars()
	ref_port.set_cursor_position(len(ref_port.text))
	port_ID = get_scan_port()


func _on_lineIPv4_text_changed(tcp_num):
	ip_scan_illegal_chars()
	ref_ipv4.set_cursor_position(len(tcp_num))
	tcp_ID = get_scan_ipv4()


func _on_lineUser_text_changed(insname):
	user_scan_bracket()
	ref_user.set_cursor_position(len(insname))
	Global.playername = insname


func _on_buttonHost_pressed():
	#print("Hosting network")
	Global.usercolor = 0
	host = NetworkedMultiplayerENet.new()
	var res = host.create_server(port_ID,2) #port_ID,Max members???
	if res != OK:
		#print("Error creating server")
		return
	get_tree().set_network_peer(host)
	$CanvasLayer/containerScreen/vboxContainer/buttonJoin.hide()
	$CanvasLayer/containerScreen/vboxContainer/buttonHost.disabled = true
	#print("DEBUG_HOST: " + str(Global.usercolor))
	clear_screen()


func _on_buttonJoin_pressed():
	#print("Joining network")
	Global.usercolor = 2
	host = NetworkedMultiplayerENet.new()
	host.create_client(tcp_ID,port_ID)
	get_tree().set_network_peer(host)
	$CanvasLayer/containerScreen/vboxContainer/buttonHost.hide()
	$CanvasLayer/containerScreen/vboxContainer/buttonJoin.disabled = true
	#print("DEBUG_JOIN: " + str(Global.usercolor))
	clear_screen()


func _on_buttonBack_pressed():
	if host != null:
		#print("Connection Closed.")
		get_tree().set_network_peer(null)
	Global.dict_user_relegate_clear()
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")


func user_scan_bracket():
	var regex = RegEx.new()
	regex.compile("\\[|\\]")
	var result = regex.search(ref_user.text)
	if result:
		var msg = ref_user.text
		msg.erase(result.get_start(),1)
		ref_user.set_text(msg)
		user_scan_bracket()


func ip_scan_illegal_chars():
	var regex = RegEx.new()
	var key = "[^0-9.]"
	regex.compile(key)
	var result = regex.search(ref_ipv4.text)
	if result:
		var msg = ref_ipv4.text
		msg.erase(result.get_start(),1)
		ref_ipv4.set_text(msg)
		ip_scan_illegal_chars()


func get_scan_ipv4() -> String:
	var regex = RegEx.new()
	var key = "\\b(?:(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\b"
	regex.compile(key)
	var result = regex.search(ref_ipv4.text)
	if result:
		return(result.get_string())
	else:
		return("127.0.0.1")


func port_scan_illegal_chars():
	var regex = RegEx.new()
	var key = "[^0-9]"
	regex.compile(key)
	var result = regex.search(ref_port.text)
	if result:
		var msg = ref_port.text
		msg.erase(result.get_start(),1)
		ref_port.set_text(msg)
		port_scan_illegal_chars()


func get_scan_port() -> int:
	var regex = RegEx.new()
	var key = "^([0-9]{1,4}|[0-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-6])$"
	regex.compile(key)
	var result = regex.search(ref_port.text)
	if result:
		return(int(int(result.get_string()) + 0))
	else:
		return(42069)
