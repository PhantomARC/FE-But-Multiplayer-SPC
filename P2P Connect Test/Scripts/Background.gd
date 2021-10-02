extends Node2D


onready var references : Dictionary = {
	"hue" : $Canvas/CenterContainer/SpriteHue,
	"square" : $Canvas/CenterContainer/AnimatedSpriteSquare,
	"diamond" : $Canvas/CenterContainer/AnimatedSpriteDiamond,
}


func _ready():
	#Declare pause mode to continue regardless.
	pause_mode = Node.PAUSE_MODE_PROCESS
	#Set initial frame to last recorded frame.
	references["square"].frame = Aesthetics.sq_frame
	references["diamond"].frame = Aesthetics.dm_frame


func _process(_delta):
	#Cycle through hues.
	references["hue"].set_modulate(Color.from_hsv(Aesthetics.hue,1,1,1))
	#Record current frame.
	Aesthetics.sq_frame = references["square"].frame
	Aesthetics.dm_frame = references["diamond"].frame

