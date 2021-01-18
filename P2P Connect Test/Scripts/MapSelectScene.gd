extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(load("res://Scenes/Background.tscn").instance())
	$CanvasLayer/gridContainer/buttonMap1.connect("pressed",
			self,"_on_buttonMap1_pressed")
	$CanvasLayer/gridContainer/buttonMap1.connect("mouse_entered",
			self,"_on_buttonMap1_mouse_entered")
	$CanvasLayer/gridContainer/buttonMap2.connect("pressed",
			self,"_on_buttonMap2_pressed")
	$CanvasLayer/gridContainer/buttonMap2.connect("mouse_entered",
			self,"_on_buttonMap2_mouse_entered")
	$CanvasLayer/gridContainer/buttonMap3.connect("pressed",
			self,"_on_buttonMap3_pressed")
	$CanvasLayer/gridContainer/buttonMap3.connect("mouse_entered",
			self,"_on_buttonMap3_mouse_entered")
	$CanvasLayer/buttonConfirm.connect("pressed",
			self,"_on_buttonConfirm_pressed")
	$CanvasLayer/buttonConfirm.connect("mouse_entered",
			self,"_on_buttonConfirm_mouse_entered")
	$CanvasLayer/buttonBack.connect("pressed",
			self,"_on_buttonBack_pressed")
	$CanvasLayer/buttonBack.connect("mouse_entered",
			self,"_on_buttonBack_mouse_entered")


func _on_buttonMap1_pressed():
	Global.map_select = 1


func _on_buttonMap2_pressed():
	Global.map_select = 2


func _on_buttonMap3_pressed():
	Global.map_select = 3


func _on_buttonMap1_mouse_entered():
	$audioSFX.play()


func _on_buttonMap2_mouse_entered():
	$audioSFX.play()


func _on_buttonMap3_mouse_entered():
	$audioSFX.play()


func _on_buttonConfirm_pressed():
	get_tree().change_scene("res://Scenes/MainScene.tscn")
	$Background.queue_free()
	queue_free()


func _on_buttonBack_pressed():
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	$Background.queue_free()
	queue_free()


func _on_buttonConfirm_mouse_entered():
	$audioSFX.play()


func _on_buttonBack_mouse_entered():
	$audioSFX.play()
