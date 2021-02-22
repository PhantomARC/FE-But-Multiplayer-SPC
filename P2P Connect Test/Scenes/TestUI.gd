extends Control


func _on_Button_button_up():
	get_tree().get_root().get_node("MainScene").turn_end = true
