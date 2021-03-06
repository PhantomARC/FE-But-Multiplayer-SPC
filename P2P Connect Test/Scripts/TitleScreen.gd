extends Node2D


#Settings Button VFX
var modwheelctr = 0
var rotate_timer = 0
var modtimer_array = [120,6,6,6,6,6]
var modwheel_array = [6,19,24,23,12,6]

signal call_settings

func _ready():
	add_child(load("res://Scenes/PauseMenu.tscn").instance())
	add_child(load("res://Scenes/Background.tscn").instance())
	$CanvasLayer/containerScreen/vboxContainer/buttonPlay.connect("pressed",
			self, "_on_buttonScene_pressed", ["res://Scenes/MapSelectScene.tscn"])
	$CanvasLayer/containerScreen/vboxContainer/buttonLobby.connect("pressed",
			self, "_on_buttonScene_pressed", ["res://Scenes/Lobby.tscn"])
	$CanvasLayer/buttonSettings.connect("pressed",
			self, "_on_buttonSettings_pressed")
	self.connect("call_settings", $PauseMenu, "_on_Resume")

func _process(_delta):
	#Settings Button VFX
	rotate_timer = rotate_timer + 1
	if rotate_timer == modtimer_array[modwheelctr]:
		$CanvasLayer/buttonSettings.rect_rotation = $CanvasLayer/buttonSettings \
				.rect_rotation + modwheel_array[modwheelctr]
		rotate_timer = 0
		modwheelctr = (modwheelctr + 1) % 6
	#Settings Button VFX End


func _on_buttonScene_pressed(scene):
	get_tree().change_scene(scene)
	queue_free()


func _on_buttonSettings_pressed():
	 emit_signal("call_settings")
