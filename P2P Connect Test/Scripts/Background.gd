extends Node2D

#Hue color derived from CowThing: https://godotengine.org/qa/5393/how-to-create-color-transition-sprite-around-the-color-wheel
onready var ae_load = get_node("/root/Aesthetics")
onready var global_load = get_node("/root/Global")


func _ready():
	setup_screen(global_load.screensize)
	$animationSquare.frame = ae_load.sq_frame
	$animationDiamond.frame = ae_load.dm_frame

func _process(delta):
	$bgHue.set_modulate(Color.from_hsv(ae_load.hue,1,1,1))
	ae_load.sq_frame = $animationSquare.frame
	ae_load.dm_frame = $animationDiamond.frame

func setup_screen(screenpos):
	$animationSquare.position = screenpos/2
	$animationDiamond.position = screenpos/2
	$bgHue.position = screenpos/2
	$bgWhite.position = screenpos/2
