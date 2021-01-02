extends Node2D

var port_ID = null
var tcp_ID = null
var host = null
var game = load("res://Scenes/IPConnect.tscn").instance()

func _ready():
	$CanvasLayer/containerScreen/vboxContainer/hboxUser/lineUser.connect("text_changed",self,"_on_lineUser_text_changed")
	$CanvasLayer/containerScreen/vboxContainer/hboxIPv4/lineIPv4.connect("text_changed",self,"_on_lineIPv4_text_changed")
	$CanvasLayer/containerScreen/vboxContainer/hboxPort/linePort.connect("text_changed",self,"_on_linePort_text_changed")
	$CanvasLayer/containerScreen/vboxContainer/buttonHost.connect("pressed",self,"_on_buttonHost_pressed")
	$CanvasLayer/containerScreen/vboxContainer/buttonJoin.connect("pressed",self,"_on_buttonJoin_pressed")
	add_child(load("res://Scenes/Background.tscn").instance())
	$CanvasLayer/buttonBack.connect("pressed",self,"_on_buttonBack_pressed")
	get_tree().connect("network_peer_connected", self, "player_connected")
	Global.playername = "User"
	tcp_ID = "25.3.252.29"
	port_ID = int(42069)


func player_connected(id):
	print("Player connected to server")
	Global.other_id = id
	get_tree().get_root().add_child(game)
	$CanvasLayer/containerScreen.hide()
	$CanvasLayer/buttonBack.hide()
	$Background.hide()


func _on_linePort_text_changed(port_num):
	port_ID = int(port_num)


func _on_lineIPv4_text_changed(tcp_num):
	tcp_ID = tcp_num


func _on_lineUser_text_changed(insname):
	Global.playername = insname


func _on_buttonHost_pressed():
	Global.usercolor = 0
	print("Hosting network")
	host = NetworkedMultiplayerENet.new()
	var res = host.create_server(port_ID,2) #port_ID,Max members???
	if res != OK:
		print("Error creating server")
		return
	get_tree().set_network_peer(host)
	$CanvasLayer/containerScreen/vboxContainer/buttonJoin.hide()
	$CanvasLayer/containerScreen/vboxContainer/buttonHost.disabled = true


func _on_buttonJoin_pressed():
	print("Joining network")
	Global.usercolor = 2
	host = NetworkedMultiplayerENet.new()
	host.create_client(tcp_ID,port_ID)
	get_tree().set_network_peer(host)
	$CanvasLayer/containerScreen/vboxContainer/buttonHost.hide()
	$CanvasLayer/containerScreen/vboxContainer/buttonJoin.disabled = true


func _on_buttonBack_pressed():
	if host != null:
		print("Connection Closed.")
		get_tree().set_network_peer(null)
	Global.dict_user_relegate_clear()
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
