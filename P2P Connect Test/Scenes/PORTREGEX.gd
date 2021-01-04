extends LineEdit

func _ready():
	set_max_length(5)


func _on_REGEX_PORT_text_changed(new_text):
	scan_illegal_chars()
	set_cursor_position(len(text))
	scan_port()



func scan_illegal_chars():
	var regex = RegEx.new()
	var key = "[^0-9]"
	regex.compile(key)
	var result = regex.search(text)
	if result:
		var msg = text
		msg.erase(result.get_start(),1)
		set_text(msg)
		scan_illegal_chars()


func scan_port():
	var regex = RegEx.new()
	var key = "^([0-9]{1,4}|[0-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-6])$"
	regex.compile(key)
	var result = regex.search(text)
	if result:
		print(str(int(result.get_string())+0))
