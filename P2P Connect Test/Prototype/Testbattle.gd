extends Control


onready var BDict = preload("res://Scripts/BattleDictionary.gd").new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	print(BDict.calc_dmg(BDict.calc_INT_FLOOR_MAX(80), BDict.calc_STR_CEILING_MAX(60), 60, 0))
