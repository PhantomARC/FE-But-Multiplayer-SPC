extends Node2D

var port_ID = null
var tcp_ID = null

onready var global = get_node("/root/Global")


func _ready():
	get_tree().connect("network_peer_connected", self, "player_connected")


func player_connected(id):
	print("Player connected to server")
	global.other_id = id
	var game = preload("res://Scenes/IPConnect.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()


func _on_Host_Button_pressed():
	print("Hosting network")
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_server(port_ID,2)
	if res != OK:
		print("Error creating server")
		return
		
	$buttonJoin.hide()
	$buttonHost.disabled = true
	get_tree().set_network_peer(host)


func _on_Join_Button_pressed():
	print("Joining network")
	var host = NetworkedMultiplayerENet.new()
	host.create_client(tcp_ID,port_ID)
	get_tree().set_network_peer(host)
	
	$buttonHost.hide()
	$buttonJoin.disabled = true


func _on_port_insert_text_changed(port_num):
	port_ID = port_num


func _on_tcp_insert_text_changed(tcp_num):
	tcp_ID = tcp_num
