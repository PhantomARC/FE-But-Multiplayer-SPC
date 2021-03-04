extends Control


onready var BDict = load("res://Scripts/BattleDictionary.gd").new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	print(BDict.calc_dmg(BDict.calc_iBDam(80), BDict.calc_sBDam(60), 60, 0))
