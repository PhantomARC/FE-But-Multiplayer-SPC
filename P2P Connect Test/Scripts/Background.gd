extends Node2D

#Hue color derived from CowThing: 
#https://godotengine.org/qa/5393/how-to-create-color-transition-sprite-around-the-color-wheel

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	$Canvas/CBox/animationSquare.frame = Aesthetics.sq_frame
	$Canvas/CBox/animationDiamond.frame = Aesthetics.dm_frame


func _process(_delta):
	$Canvas/CBox/bgHue.set_modulate(Color.from_hsv(Aesthetics.hue,1,1,1))
	Aesthetics.sq_frame = $Canvas/CBox/animationSquare.frame
	Aesthetics.dm_frame = $Canvas/CBox/animationDiamond.frame

