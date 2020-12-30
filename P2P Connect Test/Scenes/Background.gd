extends Node2D

#Hue color derived from CowThing: https://godotengine.org/qa/5393/how-to-create-color-transition-sprite-around-the-color-wheel
var hue_timer = 0
var speed = 20 #degrees per second


func _ready():
	$Square_Anim.frame = 0
	$Diamond_Anim.frame = 8

func _process(delta):
	#Simple number that goes from 0 to 360 and repeats.
	hue_timer = fmod(hue_timer + delta * speed, 360)
	var h = hue_timer / 360 #h,s,v needs to be in range 0-1

	$ColorBG.set_modulate(Color.from_hsv(h,1,1,1))
