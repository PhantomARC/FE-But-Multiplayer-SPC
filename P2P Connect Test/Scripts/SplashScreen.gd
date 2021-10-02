extends Node2D


onready var references : Dictionary = {
	"BGM" : $AudioPlayerBGM,
	"Splash" : $SpriteSplash,
	"Animation" : $AnimationPlayerSplash,
}


func _ready():
	references["BGM"].volume_db = Preferences.dict_options["bgm"]
	references["Animation"].connect("animation_finished",
			self,"_on_Animation_animation_finished")
	references["Animation"].play("DoSplashAnimation")


func _input(event): #trigger when any key is pressed
	if(event is InputEventKey):
		go_title_screen()


func _on_Animation_animation_finished(_anim_name) -> void: #post-animation
	go_title_screen()


func go_title_screen() -> void: #goes to title screen
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	queue_free()
