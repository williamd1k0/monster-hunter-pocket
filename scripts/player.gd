extends Node

export var idle = Vector2()
export var tap = Vector2()
export var hold = Vector2()
export var hold_time = 20

var press_count = 0
var sprite = nulls
var init_press = false
var one_tap = false

var in_action = 0
var blocking = false
var rolling = false
var attacking = false

signal on_attack

func _ready():
	print(self)
	sprite = get_child(0)
	set_process_input(true)
	set_process(true)
	sprite.set_scale(idle)
	show_action("Idle")
	print(get_children())
	print(Input.is_action_pressed("one_button"))


func _process(delta):
	if not is_busy():
		input_update(delta)


func input_update(delta):
	press_count += 1
	if Input.is_action_pressed("one_button"):
		if one_tap:
			rolling = true
			reset_input()
		else:
			init_press = true
			if press_count > hold_time:
				attacking = true
				sprite.set_scale(hold)
			
	elif init_press:
		if press_count < 10:
			one_tap = true
		init_press = false
		
	elif one_tap:
		if press_count > 20:
			sprite.set_scale(tap)
			blocking = true
			reset_input()
	
	else:
		sprite.set_scale(idle)
		show_action("Idle")
		reset_input()


func is_busy():
	return is_blocking() or is_rolling() or is_attacking()
	
func is_blocking():
	if blocking:
		show_action("Blocking")
		in_action += 1
		if in_action > 50:
			blocking = false
			in_action = 0
	return blocking

func is_rolling():
	if rolling:
		show_action("Rolling")
		in_action += 1
		if in_action > 60:
			rolling = false
			in_action = 0
	return rolling

func is_attacking():
	if attacking:
		show_action("Attacking")
		in_action += 1
		if in_action > 60:
			attacking = false
			in_action = 0
	return attacking

func show_action(txt):
	get_child(1).set_text(txt)


func reset_input():
	one_tap = false
	init_press = false
	press_count = 0

