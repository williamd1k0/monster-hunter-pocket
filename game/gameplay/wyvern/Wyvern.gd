extends KinematicBody2D

var debug = true

func _ready():
	set_process(true)
	set_process_input(debug)

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		translate(event.speed.normalized()*2)
		

func _process(delta):
	update()

func _on_HurtBox_area_enter( area ):
	print(area)
