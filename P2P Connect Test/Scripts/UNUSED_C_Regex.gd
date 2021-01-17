extends LineEdit


func _on_LineEdit_text_changed(text):
	#regex map coordinates
	# detects after appropriate text.
	#Valid Cases:
	# Can we go to #d4? Go to #d4. GO TO #D4!!!
	# Maybe #d4, #d4-- or even #d4+#d4.
	# We can do #d4&#d4.
	# go go go #d4
	var regex = RegEx.new()
	var key = "(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})[- .,?!/&+()]|(?<tile>#[A-Za-z]{1,2}[0-9]{1,2})$"
	regex.compile(key)
	for result in regex.search_all(text):
		#(result.get_string("tile"))
		pass
