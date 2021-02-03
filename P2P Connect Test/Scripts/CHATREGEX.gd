extends TextEdit

#updated and working anti-copypaste
var regex_key = {
	"bracketChar" : "\\[|\\]|\\r\\n|\\r|\\n",
	"chessNotation" : "(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})" \
	+ "[- .,?!/&+()]|(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})$",
	}

func _on_TextEdit_text_changed():
	scan_illegal_chars()
	cursor_set_line(0,true)
	cursor_set_column(len(get_line(0)),true)


func scan_illegal_chars():
	var regex = RegEx.new()
	regex.compile(regex_key["bracketChar"])
	var reg_cleanup = []
	for result in regex.search_all(text):
		reg_cleanup.push_back(result.get_start())
	reg_cleanup.invert()
	var msg = text
	for i in range(0, reg_cleanup.size()):
		msg.erase(reg_cleanup[i],1)
	set_text(msg)


func _input(event):
	#optimize order by earliest possible false
	if event is InputEventKey && event.pressed && event.scancode == KEY_ENTER: 
		get_tree().get_root() \
				.get_node("MainScene/Control/CanvasLayer/Panel/REGEX SEND") \
				.send_message(get_constructed_msg())
		set_text("")


func get_constructed_msg() -> String:
	var regex = RegEx.new()
	regex.compile(regex_key["chessNotation"])
	var send_queue = text
	var insert_order = []
	var metatag = []
	for result in regex.search_all(send_queue):
		metatag.push_back(result.get_string("tile"))
		insert_order.push_back(result.get_start())
		if send_queue[result.get_end()-1] in \
				['!','.',' ',',','?','/',')','-','+','&','(']:
			insert_order.push_back(result.get_end() - 1)
		else:
			insert_order.push_back(result.get_end())
	metatag.invert()
	insert_order.invert()
	var i :int = 0
	while i < insert_order.size():
		send_queue = send_queue.insert(insert_order[i],"[/url][/color]")
		send_queue = send_queue.insert(insert_order[i+1],
				"[color=#ff0000][url=" + metatag[i/2] + "]")
		i += 2
	return(send_queue)


