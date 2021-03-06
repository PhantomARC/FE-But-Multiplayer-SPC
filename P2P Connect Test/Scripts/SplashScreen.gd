extends Node2D


func _ready():
	$audioBGM.volume_db = Preferences.dict_options["bgm"]
	$animationSplash.connect("animation_finished",
			self,"_on_AnimationPlayer_animation_finished")
	$animationSplash.play("DoSplashAnimation")


func _input(event): #trigger when any key is pressed
	if(event is InputEventKey):
		go_title_screen()


func _on_AnimationPlayer_animation_finished(_anim_name): #trigger when anim done
	go_title_screen()


func go_title_screen(): #goes to title screen
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	queue_free()
