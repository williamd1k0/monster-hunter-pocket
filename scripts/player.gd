export var idle = Vector2()
export var pressed = Vector2()

func _ready():
	set_process_input(true)
	set_process(true)
	get_child(0).set_scale(idle)
	print(get_children())
	print(Input.is_action_pressed("one_button"))


func _process(delta):
	if Input.is_action_pressed("one_button"):
		self.get_child(0).set_scale(pressed)
	else:
		self.get_child(0).set_scale(idle)
		