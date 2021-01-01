extends Node2D

#Hue color derived from CowThing: 
#https://godotengine.org/qa/5393/how-to-create-color-transition-sprite-around-the-color-wheel

func _ready():
	setup_screen(Global.screensize)
	$animationSquare.frame = Aesthetics.sq_frame
	$animationDiamond.frame = Aesthetics.dm_frame

func _process(_delta):
	$bgHue.set_modulate(Color.from_hsv(Aesthetics.hue,1,1,1))
	Aesthetics.sq_frame = $animationSquare.frame
	Aesthetics.dm_frame = $animationDiamond.frame

func setup_screen(screenpos):
	$animationSquare.position = screenpos/2
	$animationDiamond.position = screenpos/2
	$bgHue.position = screenpos/2
	$bgWhite.position = screenpos/2
