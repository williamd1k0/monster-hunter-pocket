extends Node

export var life = 4350
export var idle_count = 4
export var tail_count = 1
export var fireball_count = 1
export var bite_count = 1

export var tail_force = 250
export var fireball_force = 200
export var bite_force = 300

var sprite = null
var move = 0
var moves = ['idle-fly', 'tail-attack', 'fire-ball', 'bite']
var moves_count = []
var moves_values = [idle_count, tail_count, fireball_count, bite_count]

signal on_attacked(position)
signal on_dead

func _ready():
	print("A wild drake appears!")
	sprite = get_child(0)
	sprite.get_child(0).play("drake-fly")
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

func is_dead():
	return life <= 0

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

func _on_Drake_on_attacked(position):
	print("Being attacked")


func _on_Drake_on_dead():
	print("VICTORY ACHIEVED")
