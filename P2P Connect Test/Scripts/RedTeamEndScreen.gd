extends Control


func _ready():
	add_child(load("res://Scenes/Background.tscn").instance())
	$CanvasLayer/buttonProceed.connect("pressed",self,"_on_buttonProceed_pressed")


func _on_buttonProceed_pressed():
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
