extends Node2D


func _ready():
	add_child(load("res://Scenes/Background.tscn").instance())
