extends TextureButton

var modwheelctr = 0
var rotate_timer = 0
var modtimer_array = [120,6,6,6,6,6]
var modwheel_array = [6,19,24,23,12,6]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_timer = rotate_timer + 1
	if rotate_timer == modtimer_array[modwheelctr]:
		rect_rotation = rect_rotation + modwheel_array[modwheelctr]
		rotate_timer = 0
		modwheelctr = (modwheelctr + 1) % 6
