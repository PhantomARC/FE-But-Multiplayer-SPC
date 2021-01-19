extends Control


onready var resume = $CanvasLayer/MarginContainer/CenterContainer/VBoxContainer/Button
onready var quit = $CanvasLayer/MarginContainer/CenterContainer/VBoxContainer/Button2
onready var bgm = $CanvasLayer/MarginContainer/CenterContainer/VBoxContainer/HSlider
onready var sfx = $CanvasLayer/MarginContainer/CenterContainer/VBoxContainer/HSlider2


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/Container.visible = false
	$CanvasLayer/MarginContainer.visible = false
	resume.connect("pressed",self,"_on_Resume")
	quit.connect("pressed",self,"_on_Quit")
	bgm.connect("value_changed",self,"_on_BGM_changed")
	sfx.connect("value_changed",self,"_on_SFX_changed")
	bgm.connect("mouse_exited",self,"_on_BGM_defocus")
	sfx.connect("mouse_exited",self,"_on_SFX_defocus")
	
	
	bgm.value = db2linear(Global.volume)

func _on_Resume():
	hide_all()


func _on_Quit():
	get_tree().quit()


func _on_BGM_changed(val):
	Global.volume = linear2db(val)


func _on_sfx_changed():
	pass


func _on_BGM_defocus():
	bgm.release_focus()


func _on_SFX_defocus():
	sfx.release_focus()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		hide_all()


func hide_all():
	get_tree().paused = not get_tree().paused
	$CanvasLayer/Container.visible = not $CanvasLayer/Container.visible
	$CanvasLayer/MarginContainer.visible = not $CanvasLayer/MarginContainer.visible
