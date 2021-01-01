extends Node2D

var port_ID = null
var tcp_ID = null
var host = null


func _ready():
	add_child(load("res://Scenes/Background.tscn").instance())
	$CanvasLayer/buttonBack.connect("pressed",self,"_on_buttonBack_pressed")
	get_tree().connect("network_peer_connected", self, "player_connected")


func player_connected(id):
	print("Player connected to server")
	Global.other_id = id
	var game = preload("res://Scenes/IPConnect.tscn").instance()
	get_tree().get_root().add_child(game)
	$CanvasLayer/containerScreen.hide()
	$CanvasLayer/buttonBack.hide()
	$Background.hide()


func _on_port_insert_text_changed(port_num):
	port_ID = int(port_num)


func _on_tcp_insert_text_changed(tcp_num):
	tcp_ID = tcp_num


func _on_username_input_text_changed(insname):
	Global.playername = insname


func _on_buttonHost_pressed():
	print("Hosting network")
	host = NetworkedMultiplayerENet.new()
	var res = host.create_server(port_ID,2)
	if res != OK:
		print("Error creating server")
		return
		
	$CanvasLayer/containerScreen/vboxContainer/buttonJoin.hide()
	$CanvasLayer/containerScreen/vboxContainer/buttonHost.disabled = true
	get_tree().set_network_peer(host)


func _on_buttonJoin_pressed():
	print("Joining network")
	var host = NetworkedMultiplayerENet.new()
	host.create_client(tcp_ID,port_ID)
	get_tree().set_network_peer(host)
	$CanvasLayer/containerScreen/vboxContainer/buttonHost.hide()
	$CanvasLayer/containerScreen/vboxContainer/buttonJoin.disabled = true


func _on_buttonBack_pressed():
	if host != null:
		print("Connection Closed.")
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
