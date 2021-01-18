extends AudioStreamPlayer


func _ready():
	volume_db = Global.volume
	playing = true


func _physics_process(_delta):
	volume_db = Global.volume
	if Input.is_action_just_pressed("vol_up"):
		Global.volume = Global.volume + 3
	if Input.is_action_just_pressed("vol_down"):
		Global.volume = Global.volume - 3
#optimize as key input
