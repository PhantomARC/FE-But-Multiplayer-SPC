extends RichTextLabel


#Credit to Macryc for his/her solution:
#https://godotengine.org/qa/72254/how-to-call-a-func-by-clicking-a-text-inside-a-richtextlabel
func _ready():
	connect("meta_clicked", self, "refer_tile") 


func refer_tile(returnfunc):
	print("Tile called: " + returnfunc)


func send_message(msg):
	bbcode_text += msg + "\n"
