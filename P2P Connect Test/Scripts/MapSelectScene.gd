extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Map1_button_up():
	$global.mapSelect = 1
	pass # Replace with function body.


func _on_Confirm_button_up():
	get_tree().change_scene("res://Scenes/MainScene.tscn")
	pass # Replace with function body.


func _on_Map2_button_up():
	$global.mapSelect = 2
	pass # Replace with function body.