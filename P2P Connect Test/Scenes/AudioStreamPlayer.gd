extends AudioStreamPlayer

onready var global_load = get_node("/root/Global")


func _ready():
	volume_db = global_load.volume


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
