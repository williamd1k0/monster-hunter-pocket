
extends "Character.gd"

export var idle = Vector2()
export var tap = Vector2()
export var hold = Vector2()
export var hold_time = 20
export var block_wait = 30
export var force = 64
export var left_pose = 65
export var right_pose = 275

var press_count = 0
var init_press = false
var one_tap = false

var in_action = 0
var offset = 0
var blocking = false
var rolling = false
var attacking = false

signal on_attacked(type, force)


func _ready():
	._ready()
	sprite = get_child(0)
	set_process_input(true)
	# set_process(true)
	set_fixed_process(true)
	set_initial_direction("right")
	play_animation("nyan-idle")
	set_life(life)
	show_action("Idle")


func _fixed_process(delta):
	if is_dead():
		emit_signal("on_dead")
	elif not is_busy():
		input_update(delta)


# func is_dead():
# 	return life <= 0

func input_update(delta):
	press_count += delta * 100
	if Input.is_action_pressed("one_button"):
		if one_tap:
			rolling = true
			reset_input()
		else:
			init_press = true
			if press_count > hold_time:
				attacking = true
				sprite.get_child(0).play("nyan-attack")
			
	elif init_press:
		if press_count < hold_time:
			one_tap = true
		init_press = false
		
	elif one_tap:
		if press_count > block_wait:
			block()
			reset_input()
	
	else:
		if not sprite.get_child(0).is_playing():
			play_animation("nyan-idle")
		show_action("Idle")
		reset_input()

func toggle_direction():
	.toggle_direction()

func play_animation(anim):
	.play_animation()
	sprite.get_child(0).play(anim)

func is_busy():
	if won: return true
	return is_blocking() or is_rolling() or is_attacking()

func block():
	blocking = true
	sprite.get_child(0).play("nyan-block")


func is_blocking():
	if sprite.get_child(0).get_current_animation() == "nyan-block" and sprite.get_child(0).is_playing():
		show_action("Blocking")
	else:
		blocking = false
	return blocking

func is_rolling():
	if rolling:
		if not get_parent().get_child(2).flying and get_parent().get_child(2).is_toggle_alt():
			return false
		show_action("Rolling")
		if sprite.get_child(0).get_current_animation() != "nyan-run" or not sprite.get_child(0).is_playing():
			play_animation("nyan-run")
		offset += 0.3
		print(sprite.get_pos().x)
		print(get_direction())
		if direction:
			print("indo")
			sprite.set_pos(Vector2(sprite.get_pos().x + offset, 199))
			if sprite.get_pos().x >= right_pose:
				toggle_direction()
				rolling = false
				offset = 0
		else:
			print("voltando")
			sprite.set_pos(Vector2(sprite.get_pos().x - offset, 199))
			if sprite.get_pos().x <= left_pose:
				toggle_direction()
				rolling = false
				offset = 0
	return rolling

func is_attacking():
	if sprite.get_child(0).get_current_animation() == "nyan-attack" and not sprite.get_child(0).is_playing():
		attack()
		attacking = false
		show_action("Attacking")
	return attacking

func show_action(txt):
	get_child(1).set_text(txt)

func set_life(lf):
	.set_life(lf)
	print(life_percent()/100)
	get_child(2).set_percent_visible(life_percent()/100)

func reset_input():
	one_tap = false
	init_press = false
	press_count = 0

func get_attack_force():
	return abs(force * (randi()%10+1) / 2)

func attack():
	print("ATACA VAMOO")
	get_parent().get_child(2).emit_signal("on_attacked", get_attack_force(), "right")

func _on_Player_on_attacked(type, force):
	if is_blocking():
		print("Blocked attack %s!" % type)
	elif is_rolling():
		set_life(life - force/2)
		print("Attacked by %s" % type +"! Life: %s" % life)
	else:
		set_life(life - force)
		print("Attacked by %s" % type +"! Life: %s" % life)


func _on_Player_on_dead():
	if not dead:
		dead = true
		print("YOU DIED")
		show_action("YOU DIED")


func _on_Player_on_win():
	won = true
	sprite.get_child(0).play("nyan-idle")
	sprite.get_child(0).get_animation("nyan-idle").set_loop(true)
