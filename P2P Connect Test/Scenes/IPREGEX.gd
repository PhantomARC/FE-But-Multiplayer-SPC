extends LineEdit

#old bracket regex, scans once
func _on_LineEdit_text_changed():
	scan_illegal_chars()
	set_cursor_position(len(text))
	scan_ipv4()


func scan_illegal_chars():
	var regex = RegEx.new()
	var key = "[^0-9.]"
	regex.compile(key)
	var result = regex.search(text)
	if result:
		var msg = text
		msg.erase(result.get_start(),1)
		set_text(msg)
		scan_illegal_chars()


func scan_ipv4():
	var regex = RegEx.new()
	var key = "\\b(?:(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\b"
	regex.compile(key)
	var result = regex.search(text)
	if result:
		print(result.get_string())
