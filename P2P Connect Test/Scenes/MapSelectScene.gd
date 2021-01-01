extends Node2D


onready var global_load = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(load("res://Scenes/Background.tscn").instance())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _on_Map1_button_up():
	global_load.map_select = 1


func _on_Map2_button_up():
	global_load.map_select = 2


func _on_Confirm_button_up():
	get_tree().change_scene("res://Scenes/MainScene.tscn")


func _on_Back_button_up():
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")


func _on_Map1_mouse_entered():
	$audioSFX.play()


func _on_Map2_mouse_entered():
	$audioSFX.play()


func _on_Confirm_mouse_entered():
	$audioSFX.play()


func _on_Back_mouse_entered():
	$audioSFX.play()


func _on_Map3_button_up():
	global_load.map_select = 3


func _on_Map3_mouse_entered():
	$audioSFX.play()
