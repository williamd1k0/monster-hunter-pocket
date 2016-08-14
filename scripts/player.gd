extends Node

export var idle = Vector2()
export var tap = Vector2()
export var hold = Vector2()
export var hold_time = 20

var press_count = 0

func _ready():
	set_process_input(true)
	set_process(true)
	get_child(0).set_scale(idle)
	get_child(0).get_child(0).play("idle")
	print(get_children())
	print(Input.is_action_pressed("one_button"))
	

func _process(delta):
	press_count += 1
	if Input.is_action_pressed("one_button"):
		if press_count > hold_time:
			self.get_child(0).set_scale(hold)
		else:
			self.get_child(0).set_scale(tap)
	else:
		press_count = 0
		self.get_child(0).set_scale(idle)
		