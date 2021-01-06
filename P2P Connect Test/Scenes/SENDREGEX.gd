extends RichTextLabel


#Credit to Macryc for his/her solution:
#https://godotengine.org/qa/72254/how-to-call-a-func-by-clicking-a-text-inside-a-richtextlabel
func _ready():
	connect("meta_clicked", get_tree().get_root().get_node("MainScene/Camera2D"), "refer_tile") 


func send_message(msg):
	bbcode_text += msg + "\n"

