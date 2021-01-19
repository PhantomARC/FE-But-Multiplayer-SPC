extends Node2D

var port_ID : int = 0
var ipv4_ID : String = ""
var host = null
var regex_key = {
	"IPv4Char" : "[^0-9.]",
	"portChar" : "[^0-9]",
	"userChar" : "\\[|\\]",
	"IPv4Scan" : "\\b(?:(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.){3}(?:25[0-5]|" \
	+ "2[0-4]\\d|[01]?\\d\\d?)\\b",
	"portScan" : "^([0-9]{1,4}|[0-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|" \
	+ "655[0-2][0-9]|6553[0-6])$",
}


onready var ref_user = $CanvasLayer/containerScreen/ \
		vboxContainer/hboxUser/lineUser
onready var ref_ipv4 = $CanvasLayer/containerScreen/ \
		vboxContainer/hboxIPv4/lineIPv4
onready var ref_port = $CanvasLayer/containerScreen/ \
		vboxContainer/hboxPort/linePort


func _ready():
	ref_user.connect("text_changed",self,"_on_lineUser_text_changed")
	ref_ipv4.connect("text_changed",self,"_on_lineIPv4_text_changed")
	ref_port.connect("text_changed",self,"_on_linePort_text_changed")
	$CanvasLayer/containerScreen/vboxContainer/buttonHost.connect("pressed",
			self,"_on_buttonHost_pressed")
	$CanvasLayer/containerScreen/vboxContainer/buttonJoin.connect("pressed",
			self,"_on_buttonJoin_pressed")
	$CanvasLayer/buttonBack.connect("pressed",self,"_on_buttonBack_pressed")
	
	add_child(load("res://Scenes/Background.tscn").instance())
	ref_port.set_max_length(5)
	
	Global.playername = "User"
	ipv4_ID = "25.3.252.29"
	port_ID = int(42069)


func clear_screen() -> void:
	$CanvasLayer/containerScreen.queue_free()
	add_child(load("res://Scenes/PauseMenu.tscn").instance())
	add_child(load("res://Scenes/IPConnect.tscn").instance())
	Global.dict_user_relegate[1] = Global.playername
	Global.dict_user_color[1] = Aesthetics.color_code[Global.usercolor]


func _on_linePort_text_changed(_text):
	regex_filter("portChar",ref_port)
	port_ID = regex_grab("portScan",ref_port,42069) as int


func _on_lineIPv4_text_changed(_text):
	regex_filter("IPv4Char",ref_ipv4)
	ipv4_ID = regex_grab("IPv4Scan",ref_ipv4,"127.0.0.1") as String


func _on_lineUser_text_changed(input_name):
	regex_filter("userChar",ref_user)
	Global.playername = input_name


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
	$Background.queue_free()
	clear_screen()


func _on_buttonJoin_pressed():
	#print("Joining network")
	Global.usercolor = 2
	host = NetworkedMultiplayerENet.new()
	host.create_client(ipv4_ID,port_ID)
	get_tree().set_network_peer(host)
	$CanvasLayer/containerScreen/vboxContainer/buttonHost.hide()
	$CanvasLayer/containerScreen/vboxContainer/buttonJoin.disabled = true
	$Background.queue_free()
	clear_screen()


func _on_buttonBack_pressed():
	if host != null:
		#print("Connection Closed.")
		get_tree().set_network_peer(null)
	Global.dict_user_relegate_clear()
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	if get_node_or_null("Background"):
		$Background.queue_free()
	if get_node_or_null("ChatRoom"):
		$ChatRoom.queue_free()
	queue_free()


func regex_filter(boxType,nodePath) -> void:
	var regex  = RegEx.new()
	var reg_cleanup = []
	var message = nodePath.text
	regex.compile(regex_key[boxType])
	for result in regex.search_all(nodePath.text):
		reg_cleanup.push_back(result.get_start())
	reg_cleanup.invert()
	for i in range(0, reg_cleanup.size()):
		message.erase(reg_cleanup[i],1)
	nodePath.set_text(message)
	nodePath.set_cursor_position(len(nodePath.text))


func regex_grab(boxType,nodePath,fallbackVal):
	var regex = RegEx.new()
	regex.compile(regex_key[boxType])
	var result = regex.search(nodePath.text)
	if result:
		return(result.get_string())
	else:
		return(fallbackVal)
