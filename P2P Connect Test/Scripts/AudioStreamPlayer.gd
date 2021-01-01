extends AudioStreamPlayer


onready var global_load = get_node("/root/Global")


func _ready():
	playing = false
	volume_db = global_load.volume
	playing = true


func _physics_process(delta):
	volume_db = global_load.volume
	if Input.is_action_just_pressed("vol_up"):
		global_load.volume = global_load.volume + 3
	if Input.is_action_just_pressed("vol_down"):
		global_load.volume = global_load.volume - 3
