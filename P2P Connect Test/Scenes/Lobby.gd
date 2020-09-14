extends Node2D


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
	var res = host.create_server(26497,2)
	if res != OK:
		print("Error creating server")
		return
		
	$buttonJoin.hide()
	$buttonHost.disabled = true
	get_tree().set_network_peer(host)


func _on_Join_Button_pressed():
	print("Joining network")
	var host = NetworkedMultiplayerENet.new()
	host.create_client("25.3.252.29",26497)
	get_tree().set_network_peer(host)
	
	$buttonHost.hide()
	$buttonJoin.disabled = true
