extends Control

onready var chat_input_label = $containerScreen/textureBackPanel/textureInputPanel/textInput
onready var chat_display = $containerScreen/textureBackPanel/textureChatPanel/richtextChat
onready var chat_input = $containerScreen/textureBackPanel/textureInputPanel/textInput

var color_rep = [
	"#c90ac9", #purple
	"#d49f00", #gold
	"#00baae" #teal
	]


func _ready():
	get_tree().connect("connected_to_server", self, "user_entered")
	chat_input.connect("text_changed",self,"_on_textInput_text_changed")
	chat_input.connect("focus_entered",self,"_on_textInput_focus_entered")
	chat_input.connect("focus_exited",self,"_on_textInput_focus_exited")
	chat_input.set_text("Type Message Here...")
	chat_input.set("custom_colors/font_color", Color(0.88,0.88,0.88,1))

func _input(event):
	if event is InputEventKey:
		if event.pressed && event.scancode == KEY_ENTER:
			if chat_input.has_focus():
				if chat_input.text != "":
					send_message()
				else:
					chat_input.release_focus()
			else:
				chat_input.grab_focus()
			get_tree().set_input_as_handled()
		if event.pressed and event.scancode == KEY_ESCAPE:
			if chat_input.has_focus():
				chat_input.release_focus()


func send_message():
	var msg = chat_input.text
	chat_input.text = ""
	var id = get_tree().get_network_unique_id()
	rpc("receive_message", Global.playername, msg, color_rep[Global.usercolor])


sync func receive_message(id, msg, idcol):
	chat_display.bbcode_text += "[color=" + idcol + "]"+ id + ":[/color] "
	chat_display.bbcode_text += "[color=#808080]" + msg + "[/color]"
	chat_display.bbcode_text += "\n"


func _on_textInput_text_changed():
	pass


func _on_textInput_focus_entered():
	chat_input.set("custom_colors/font_color", Color("#595959"))
	if chat_input.text == "Type Message Here...":
		chat_input.set_text("")


func _on_textInput_focus_exited():
	chat_input.set("custom_colors/font_color", Color(0.88,0.88,0.88,1))
	if chat_input.text == "":
		chat_input.set_text("Type Message Here...")


func user_entered():
	rpc("receive_user", Global.playername, color_rep[Global.usercolor])


sync func receive_user(id, idcol):
	chat_display.bbcode_text += "[color=" + idcol + "]"+ id + "[/color] "
	chat_display.bbcode_text += "[color=#808080]joined the server.[/color]"
	chat_display.bbcode_text += "\n"
