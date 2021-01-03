extends LineEdit


func _on_LineEdit_text_changed(new_text):
	var regex = RegEx.new()
	regex.compile("\\[|\\]")
	var result = regex.search(text)
	if result:
		var msg = text
		msg.erase(result.get_start(),1)
		set_text(msg)
		set_cursor_position(result.get_start())
