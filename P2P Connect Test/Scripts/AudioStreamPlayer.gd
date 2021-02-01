extends AudioStreamPlayer


func _ready():
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	change_vol()
	playing = true
	add_to_group("bgm_vol")

func change_vol():
	volume_db = Global.dict_options["bgm"]
