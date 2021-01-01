extends AudioStreamPlayer


onready var global_load = get_node("/root/Global")


func _physics_process(delta):
	volume_db = global_load.sfxvol
