extends Control

onready var chat_display = $containerScreen/textureBackPanel/textureChatPanel/richtextChat
onready var chat_input = $containerScreen/textureBackPanel/textureInputPanel/lineInput

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			send_message()

func send_message():
	var msg = chat_input.text
	chat_input.text = ""
	var id = get_tree().get_network_unique_id()
	rpc("receive_message", Global.playername, msg)

sync func receive_message(id, msg):
	chat_display.text += str(id) + ": " + msg + "\n"
