extends Viewport


func _ready():
	add_child(load("res://Scenes/MainScene.tscn").instance())
