
extends "Character.gd"

export var idle_count = 4
export var tail_count = 1
export var fireball_count = 1
export var bite_count = 1

export var tail_force = 75
export var fireball_force = 50
export var bite_force = 98

var move = 0
var moves = ['idle-fly', 'tail-attack', 'fire-ball', 'bite']
var moves_count = []
var moves_values = [idle_count, tail_count, fireball_count, bite_count]


signal on_attacked(force, position)

func _ready():
	._ready()
	print("A wild drake appears!")
	sprite = get_child(0)
	sprite.get_child(0).play("drake-fly")
	set_life(life)
	set_fixed_process(true)
	for count in range(0, moves_values.size()):
		for move in range(0, moves_values[count]):
			moves_count.append(count)
	
	print(moves_count)
	get_move()

func _fixed_process(delta):
	# print(sprite.get_child(0).get_current_animation())
	if is_dead():
		emit_signal("on_dead")
	elif not is_busy():
		move = get_move()
		do_move(move)
		sprite.get_child(0).play("drake-fly")

# func is_dead():
# 	return life <= 0

func is_busy():
	return sprite.get_child(0).is_playing()

func get_move():
	randomize()
	var rangei = int(rand_range(0, moves_count.size()))
	return moves_count[rangei]

func do_move(moveid):
	if moveid == 0:
		idle_fly()
	elif moveid == 1:
		tail_attack()
	elif moveid == 2:
		fire_ball()
	elif moveid == 3:
		bite()

func idle_fly():
	print("Flying")

func tail_attack():
	print("Tail Attack")
	attack("Tail Attack", tail_force)

func fire_ball():
	print("Fire Ball")
	attack("Fire Ball", fireball_force)

func bite():
	print("Bite")
	attack("Bite", bite_force)

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
			get_node("Hit").hit(force / 2)
			set_life(life - (force / 2))
		else:
			print("Full hit!")
			get_node("Hit").hit(force)
			set_life(life - force)


func _on_Drake_on_dead():
	if not dead:
		dead = true
		get_parent().get_node("Player").emit_signal("on_win")
		get_child(1).set_text("VICTORY ACHIEVED")
	