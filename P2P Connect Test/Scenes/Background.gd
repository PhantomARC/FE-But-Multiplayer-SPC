extends Node2D

#Hue color derived from CowThing: https://godotengine.org/qa/5393/how-to-create-color-transition-sprite-around-the-color-wheel
onready var ae_load = get_node("/root/Aesthetics")


func _ready():
	$Square_Anim.frame = ae_load.sq_frame
	$Diamond_Anim.frame = ae_load.dm_frame

func _process(delta):
	$ColorBG.set_modulate(Color.from_hsv(ae_load.hue,1,1,1))
	ae_load.sq_frame = $Square_Anim.frame
	ae_load.dm_frame = $Diamond_Anim.frame
