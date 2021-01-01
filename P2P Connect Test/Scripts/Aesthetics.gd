extends Node


#Hue color derived from CowThing: https://godotengine.org/qa/5393/how-to-create-color-transition-sprite-around-the-color-wheel
var hue_timer = 0
var speed = 20
var sq_frame = 0
var dm_frame = 8
var hue = 0


func _process(delta):
	hue_timer = fmod(hue_timer + delta * speed, 360)
	hue = hue_timer / 360