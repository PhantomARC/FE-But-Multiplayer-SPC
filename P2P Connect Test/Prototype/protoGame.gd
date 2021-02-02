extends Node2D


onready var p1pos = $p1pos
onready var p2pos = $p2pos


func _ready():
	var p1 = preload("res://Prototype/protoPlayer.tscn").instance()
	p1.name = (str(get_tree().get_network_unique_id()))
	p1.set_network_master(get_tree().get_network_unique_id())
	p1.global_transform = p1pos.global_transform
	add_child(p1)
	
	var p2 = preload("res://Prototype/protoPlayer.tscn").instance()
	p2.name = (str(Global.other_id))
	p2.set_network_master(Global.other_id)
	p2.global_transform = p2pos.global_transform
	add_child(p2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
