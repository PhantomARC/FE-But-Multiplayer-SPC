extends Control

onready var global_load = get_node("/root/Global")
onready var chat_display = $RoomUI/ChatDisplay
onready var chat_input = $RoomUI/ChatInput

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			send_message()

func send_message():
	var msg = chat_input.text
	chat_input.text = ""
	var id = get_tree().get_network_unique_id()
	rpc("receive_message", global_load.playername, msg)

sync func receive_message(id, msg):
	chat_display.text += str(id) + ": " + msg + "\n"
