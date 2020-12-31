extends TextureButton


var rotate_timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_timer = rotate_timer + 1
	if rotate_timer == 15:
		rect_rotation = rect_rotation + 15
		rotate_timer = 0
