extends TextEdit

#updated and working anti-copypaste
var send_queue = ""


func _on_TextEdit_text_changed():
	scan_bracket()
	scan_lines()
	index_coords()
	cursor_set_line(0,true)
	cursor_set_column(len(get_line(0)),true)

func scan_bracket():
	var regex = RegEx.new()
	var key = "\\[|\\]"
	regex.compile(key)
	var result = regex.search(text)
	if result:
		var msg = text
		msg.erase(result.get_start(),1)
		set_text(msg)
		scan_bracket()


func scan_lines():
	var regex = RegEx.new()
	var key = "(\\r\\n|\\r|\\n)"
	regex.compile(key)
	var result = regex.search(text)
	if result:
		var msg = text
		msg.erase(result.get_start(),1)
		set_text(msg)
		scan_lines()


func index_coords():
	var regex = RegEx.new()
	var key = "(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})[- .,?!/&+]|(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})$"
	regex.compile(key)
	
	for result in regex.search_all(text):
		print(result.get_string("tile"))


func _input(event):
	if event is InputEventKey:
		if event.pressed && event.scancode == KEY_ENTER:
			construct_msg()
			get_tree().get_root().get_node("Control/Panel/REGEX SEND").send_message(send_queue)
			set_text("")


func construct_msg():
	var regex = RegEx.new()
	var key = "(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})[- .,?!/&+]|(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})$"
	regex.compile(key)
	send_queue = text
	var insert_order = []
	print(send_queue)
	for result in regex.search_all(send_queue):
		insert_order.push_front(result.get_start())
		if send_queue[result.get_end()-1] in ['-',' ','.',',','?','!','/','&','+']:
			insert_order.push_front(result.get_end()-1)
		else:
			insert_order.push_front(result.get_end())
	var ctr = 0
	while ctr < insert_order.size():
		print(str(insert_order[ctr]))
		send_queue = send_queue.insert(insert_order[ctr],"[/color]")
		ctr = ctr + 1
		send_queue = send_queue.insert(insert_order[ctr],"[color=#ff0000]")
		ctr = ctr + 1
	print(send_queue)
