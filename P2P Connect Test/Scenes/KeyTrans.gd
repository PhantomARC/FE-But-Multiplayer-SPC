extends TouchScreenButton

onready var global_load = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready():
	self_modulate = Color(1, 1, 1, global_load.transparency)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass