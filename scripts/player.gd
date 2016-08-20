
extends "Character.gd"

export var idle = Vector2()
export var tap = Vector2()
export var hold = Vector2()
export var hold_time = 20
export var block_wait = 30
export var force = 64

var press_count = 0
var init_press = false
var one_tap = false

var in_action = 0
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
			toggle_direction()
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
	if direction:
		sprite.set_pos(Vector2(275, 200))
	else:
		sprite.set_pos(Vector2(65, 200))
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
		show_action("Rolling")
		in_action += 1
		if in_action > 60:
			rolling = false
			in_action = 0
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
	get_child(2).set_text("U HP: %s" % life)

func reset_input():
	one_tap = false
	init_press = false
	press_count = 0

func get_attack_force():
	return abs(force * randi() / 2)

func attack():
	print("ATACA VAMOO")
	get_parent().get_child(2).emit_signal("on_attacked", get_attack_force(), "right")

func _on_Player_on_attacked(type, force):
	if is_blocking():
		show_action("Blocked attack %s!" % type)
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
