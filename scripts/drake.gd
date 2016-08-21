
extends "Character.gd"

export var idle_count = 4
export var tail_count = 1
export var fireball_count = 1
export var bite_count = 1
export var toggle_alt_count = 1

export var tail_force = 75
export var fireball_force = 50
export var bite_force = 98

export var tail_cost = 2
export var fireball_cost = 1
export var bite_cost = 3
export var stamina = 0

var move = 0
var moves = ['idle-fly', 'tail-attack', 'fire-ball', 'bite', 'toggle-alt']
var moves_count = []
var moves_values = [idle_count, tail_count, fireball_count, bite_count, toggle_alt_count]
var player_direction = null
var is_backwards = false
var flying = true
var fire_ball_move = false
var bite_move = false

signal on_attacked(force, position)

func _ready():
	._ready()
	print("A wild drake appears!")
	sprite = get_child(0)
	set_initial_direction("left")
	play_animation("drake-fly")
	set_life(life)
	set_fixed_process(true)
	for count in range(0, moves_values.size()):
		for move in range(0, moves_values[count]):
			moves_count.append(count)
	
	print(moves_count)
	#get_move()

func _fixed_process(delta):
	# print(sprite.get_child(0).get_current_animation())
	if is_dead():
		emit_signal("on_dead")
	elif not is_busy():
		check_player_dir()
		move = get_move()
		do_move(move)

# func is_dead():
# 	return life <= 0

func is_busy():
	return is_fire_ball() or is_flying() or is_toggle_alt() or is_bite()

func play_animation(anim):
	.play_animation()
	sprite.get_child(0).play(anim)

func check_player_dir():
	player_direction = get_parent().get_child(1).direction
	if player_direction == direction:
		print("DE COSTAS PRO CARA MEUO")
		is_backwards = true
	else:
		is_backwards = false


func get_move():
	if is_backwards:
		return -1
	randomize()
	var rangei = int(rand_range(0, moves_count.size()))
	return moves_count[rangei]

func do_move(moveid):
	if moveid == -1:
		toggle_direction()
	
	if moveid == 4:
		toggle_altitude()
	elif flying:
		if moveid == 0:
			idle_fly()
		elif moveid == 2:
			fire_ball()
		else:
			idle_fly()
	else:
		if moveid == 1:
			tail_attack()
		elif moveid == 3:
			bite()
		else:
			idle_ground()

func has_stamina(cost):
	return stamina >= cost

func idle_fly():
	print("Flying")
	play_animation("drake-fly")
	stamina += 1

func idle_ground():
	print("Wait")
	#play_animation("drake-fly")
	stamina += 1

func is_flying():
	return sprite.get_child(0).is_playing() and sprite.get_child(0).get_current_animation() == "drake-fly"

func tail_attack():
	if has_stamina(tail_cost):
		print("Tail Attack")
		#play_animation("drake-fly")
		attack("Tail Attack", tail_force)
	else:
		idle_ground()

func fire_ball():
	if has_stamina(fireball_cost):
		play_animation("drake-fire")
		fire_ball_move = true
	else:
		idle_fly()

func is_fire_ball():
	if fire_ball_move:
		if not sprite.get_child(0).is_playing() and sprite.get_child(0).get_current_animation() == "drake-fire":
			print("Fire Ball")
			attack("Fire Ball", fireball_force)
			fire_ball_move = false
	return fire_ball_move

func bite():
	if has_stamina(bite_cost):
		play_animation("drake-bite")
		bite_move = true
	else:
		idle_ground()

func is_bite():
	if bite_move:
		if not sprite.get_child(0).is_playing() and sprite.get_child(0).get_current_animation() == "drake-bite":
			print("Bite")
			attack("Bite", bite_force)
			bite_move = false
	return bite_move

func toggle_altitude():
	if flying:
		turn_down()
	else:
		turn_up()
	flying = not flying

func is_toggle_alt():
	return sprite.get_child(0).is_playing() and sprite.get_child(0).get_current_animation() in ["drake-up", "drake-down"]

func turn_up():
	play_animation("drake-up")

func turn_down():
	play_animation("drake-down")

func attack(type, force):
	get_parent().get_child(1).emit_signal("on_attacked", type, force)

func is_attacking():
	if sprite.get_child(0).is_playing():
		var anim = sprite.get_child(0).get_current_animation()
		print(anim)
		if not anim in ['drake-fly', 'drake-fly-mirror']:
			return true
	else:
		return false


func set_life(lf):
	.set_life(lf)
	get_child(1).set_text("HP: %s" % life)

func _on_Drake_on_attacked(force, position):
	if not is_dead():
		if is_attacking():
			print("Weak hit!")
			get_node("Hit").hit(force / 2, sprite.get_pos())
			set_life(life - (force / 2))
		else:
			print("Full hit!")
			get_node("Hit").hit(force, sprite.get_pos())
			set_life(life - force)


func _on_Drake_on_dead():
	if not dead:
		dead = true
		get_parent().get_node("Player").emit_signal("on_win")
		get_child(1).set_text("VICTORY ACHIEVED")
	

func _on_Drake_on_win():
	won = true
	sprite.get_child(0).play("drake-fly")
	sprite.get_child(0).get_animation("drake-fly").set_loop(true)
	get_parent().emit_signal("on_gameover", "drake")
