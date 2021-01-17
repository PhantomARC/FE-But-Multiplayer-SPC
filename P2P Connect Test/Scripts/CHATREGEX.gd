extends TextEdit

#updated and working anti-copypaste
var send_queue = ""


func _on_TextEdit_text_changed():
	scan_illegal_chars()
	cursor_set_line(0,true)
	cursor_set_column(len(get_line(0)),true)

func scan_illegal_chars():
	var regex = RegEx.new()
	var key = "\\[|\\]|\\r\\n|\\r|\\n"
	regex.compile(key)
	var result = regex.search(text)
	if result:
		var msg = text
		msg.erase(result.get_start(),1)
		set_text(msg)
		scan_illegal_chars()


func _input(event):
	if event is InputEventKey:
		if event.pressed && event.scancode == KEY_ENTER:
			construct_msg()
			get_tree().get_root().get_node("MainScene/Control/CanvasLayer/Panel/REGEX SEND").send_message(send_queue)
			set_text("")


func construct_msg():
	var regex = RegEx.new()
	var key = "(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})[- .,?!/&+()]|(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})$"
	regex.compile(key)
	send_queue = text
	var insert_order = []
	var metatag = []
	for result in regex.search_all(send_queue):
		metatag.push_front(result.get_string("tile"))
		insert_order.push_front(result.get_start())
		if send_queue[result.get_end()-1] in ['-',' ','.',',','?','!','/','&','+','(',')']:
			insert_order.push_front(result.get_end()-1)
		else:
			insert_order.push_front(result.get_end())
	var ctr = 0
	while ctr < insert_order.size():
		send_queue = send_queue.insert(insert_order[ctr],"[/url][/color]")
		ctr = ctr + 1
		send_queue = send_queue.insert(insert_order[ctr],"[color=#ff0000][url=" + metatag[(ctr-1)/2] + "]")
		ctr = ctr + 1
	print(send_queue)
