extends Node

export var idle = Vector2()
export var tap = Vector2()
export var hold = Vector2()
export var hold_time = 20

var press_count = 0
var sprite = null

func _ready():
	sprite = get_child(0)
	set_process_input(true)
	set_process(true)
	sprite.set_scale(idle)
	sprite.get_child(0).play("idle")
	print(get_children())
	print(Input.is_action_pressed("one_button"))
	

func _process(delta):
	press_count += 1
	if Input.is_action_pressed("one_button"):
		if press_count > hold_time:
			sprite.set_scale(hold)
		else:
			sprite.set_scale(tap)
	else:
		press_count = 0
		sprite.set_scale(idle)
		