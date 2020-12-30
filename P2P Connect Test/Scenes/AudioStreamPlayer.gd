extends AudioStreamPlayer

onready var global_load = get_node("/root/Global")


func _ready():
	volume_db = global_load.volume


func _physics_process(delta):
	volume_db = global_load.volume
	if Input.is_action_just_pressed("vol_up"):
		global_load.volume = global_load.volume + 3
	if Input.is_action_just_pressed("vol_down"):
		global_load.volume = global_load.volume - 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
