extends Node
# Aesthetics is a global autoload which defines colors, animations and other
# non-integral visual features.


#Hue color derived from CowThing:https://godotengine.org/qa/5393/
const SPEED : int = 20


var hue_timer : float = 0.000
var sq_frame : int = 0
var dm_frame : int = 8
var hue : float = 0.000

var color_code : Array = [
	"#c90ac9", #purple
	"#d49f00", #gold
	"#00baae", #teal
	]

func _process(delta):
	hue_timer = fmod(hue_timer + delta * SPEED, 360)
	hue = hue_timer / 360
