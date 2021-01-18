extends Node2D


#Settings Button VFX
var modwheelctr = 0
var rotate_timer = 0
var modtimer_array = [120,6,6,6,6,6]
var modwheel_array = [6,19,24,23,12,6]


func _ready():
	add_child(load("res://Scenes/Background.tscn").instance())
	$CanvasLayer/containerScreen/vboxContainer/buttonPlay.connect("pressed",
			self,"_on_buttonPlay_pressed")
	$CanvasLayer/containerScreen/vboxContainer/buttonLobby.connect("pressed",
			self,"_on_buttonLobby_pressed")


func _process(_delta):
	#Settings Button VFX
	rotate_timer = rotate_timer + 1
	if rotate_timer == modtimer_array[modwheelctr]:
		$CanvasLayer/buttonSettings.rect_rotation = $CanvasLayer/buttonSettings \
				.rect_rotation + modwheel_array[modwheelctr]
		rotate_timer = 0
		modwheelctr = (modwheelctr + 1) % 6
	#Settins Button VFX End


func _on_buttonPlay_pressed():
	get_tree().change_scene("res://Scenes/MapSelectScene.tscn")
	$Background.queue_free()
	queue_free()


func _on_buttonLobby_pressed():
	get_tree().change_scene("res://Scenes/Lobby.tscn")
	$Background.queue_free()
	queue_free()
