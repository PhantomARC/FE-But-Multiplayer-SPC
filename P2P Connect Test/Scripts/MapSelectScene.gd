extends Node2D

onready var btn = [
	$CanvasLayer/gridContainer/buttonMap1,
	$CanvasLayer/gridContainer/buttonMap2,
	$CanvasLayer/gridContainer/buttonMap3,
]


func _ready():
	add_child(load("res://Scenes/Background.tscn").instance())
	for loc in btn: #for each child node in the buttons array
		loc.connect("pressed", self,"_on_buttonMap_pressed", [btn.find(loc,0)])
		loc.connect("mouse_entered", self,"_on_buttonAny_mouse_entered")
	$CanvasLayer/buttonConfirm.connect("pressed",
			self,"_on_buttonScene_pressed", ["res://Scenes/GameScene.tscn"])
	$CanvasLayer/buttonConfirm.connect("mouse_entered",
			self,"_on_buttonAny_mouse_entered")
	$CanvasLayer/buttonBack.connect("pressed",
			self,"_on_buttonScene_pressed", ["res://Scenes/TitleScreen.tscn"])
	$CanvasLayer/buttonBack.connect("mouse_entered",
			self,"_on_buttonAny_mouse_entered")


func _on_buttonMap_pressed(num):
	Global.map_num = num


func _on_buttonAny_mouse_entered():
	$audioSFX.play()


func _on_buttonScene_pressed(scene_path):
	get_tree().change_scene(scene_path)
	queue_free()

