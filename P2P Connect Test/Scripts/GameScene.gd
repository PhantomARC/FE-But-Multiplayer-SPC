extends Control


func _ready():
	add_child(load("res://Scenes/PauseMenu.tscn").instance())
