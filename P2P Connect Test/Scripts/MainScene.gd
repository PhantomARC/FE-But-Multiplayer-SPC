extends Node2D

var selectMap = null

func go_to_red_team_end_screen():
	get_tree().change_scene("res://Scenes/RedTeamEndScreen.tscn")

func go_to_blue_team_end_screen():
	get_tree().change_scene("res://Scenes/BlueTeamEndScreen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if $global.mapSelect == 1:
		selectMap = load("res://Sprites/MapVolcano.tscn")
	elif $global.mapSelect == 2:
		selectMap = load("res://Sprites/MapPlains.tscn")
	var loadMap = selectMap.instance()
	add_child(loadMap)

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player.get_step_count() == 20: #and is_on_red_team()
		go_to_red_team_end_screen()
	#if $Player.get_step_count() == 10: #and is_on_blue_team()
		#go_to_blue_team_end_screen()
