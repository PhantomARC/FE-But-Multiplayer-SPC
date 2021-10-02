extends Control


func _on_Button_button_up():
	get_tree().get_root().get_node("GameScene/Canvas/HSBox/VSBox_L/ViewBox/Viewport/MainScene").turn_end = true

#rep  w/find node D:
