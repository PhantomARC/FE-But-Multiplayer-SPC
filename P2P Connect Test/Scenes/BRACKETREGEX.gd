extends LineEdit

#new recursive bracket regex
func _on_LineEdit_text_changed():
	scan_bracket()
	set_cursor_position(len(text))


func scan_bracket():
	var regex = RegEx.new()
	regex.compile("\\[|\\]")
	var result = regex.search(text)
	if result:
		var msg = text
		msg.erase(result.get_start(),1)
		set_text(msg)
		scan_bracket()
