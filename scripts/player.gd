extends Node

export var idle = Vector2()
export var tap = Vector2()
export var hold = Vector2()
export var hold_time = 20

var press_count = 0
var sprite = null
var init_press = false
var one_tap = false

var blocking = false
var rolling = false
var atacking = false

func _ready():
	sprite = get_child(0)
	set_process_input(true)
	set_process(true)
	sprite.set_scale(idle)
	show_action("Idle")
	print(get_children())
	print(Input.is_action_pressed("one_button"))
	

func _process(delta):
	if not is_busy():
		press_count += 1
		if Input.is_action_pressed("one_button"):
			if one_tap:
				show_action("Roll")
				reset_input()
			else:
				init_press = true
				if press_count > hold_time:
					show_action("Attack")
					sprite.set_scale(hold)
				
		elif init_press:
			if press_count < 10:
				one_tap = true
			init_press = false
			
		elif one_tap:
			if press_count > 20:
				show_action("Block")
				sprite.set_scale(tap)
				reset_input()
		
		else:
			sprite.set_scale(idle)
			reset_input()


func is_busy():
	return blocking or rolling or atacking

func show_action(txt):
	get_child(1).set_text(txt)


func reset_input():
	one_tap = false
	init_press = false
	press_count = 0