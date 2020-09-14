extends Button


func _ready():
	pass


func _on_Lobby_Button_pressed():#when triggered, change scene
	get_tree().change_scene("res://Scenes/Lobby.tscn")
