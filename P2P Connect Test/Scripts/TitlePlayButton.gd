extends Button

func _ready():
	pass

func _on_Button_button_down(): #when triggered, change scene
	get_tree().change_scene("res://Scenes/MapSelectScene.tscn")
