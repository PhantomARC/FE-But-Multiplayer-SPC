extends Node2D


onready var references : Dictionary = {
	"attack_button" : $VBoxContainerOutside/VBoxContainerInside/HBoxContainerAttackOptions/ButtonAttack
}


func _ready():
	references["attack_button"].rect_position = Vector2.ZERO
	# is equivalent to
	$VBoxContainerOutside/VBoxContainerInside/HBoxContainerAttackOptions/ButtonAttack.rect_position = Vector2.ZERO
