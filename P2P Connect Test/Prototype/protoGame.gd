extends Node2D


func _ready():
	add_to_group("multiplayer")
	
	var p1 = preload("res://Prototype/protoPlayer.tscn").instance()
	p1.name = (str(get_tree().get_network_unique_id()))
	p1.set_network_master(get_tree().get_network_unique_id())
	p1.position = Vector2(20,20)
	add_child(p1)
	
	var p2 = preload("res://Prototype/protoPlayer.tscn").instance()
	p2.name = (str(Global.other_id))
	p2.set_network_master(Global.other_id)
	p2.position = Vector2(100,100)
	add_child(p2)
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
