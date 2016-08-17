extends Node

export var life = 4350
export var idle_count = 4
export var tail_count = 1
export var fireball_count = 1
export var bite_count = 1

var sprite = null
var move = 0
var moves = ['idle-fly', 'tail-attack', 'fire-ball', 'bite']
var moves_count = []
var moves_values = [idle_count, tail_count, fireball_count, bite_count]

signal on_attacked

func _ready():
	print("A wild drake appears!")
	sprite = get_child(0)
	sprite.get_child(0).play("drake-fly")
	set_process(true)
	for count in range(0, moves_values.size()):
		for move in range(0, moves_values[count]):
			moves_count.append(count)
	
	print(moves_count)
	get_move()

func _process(delta):
	# print(sprite.get_child(0).get_current_animation())
	if not is_busy():
		move = get_move()
		do_move(move)
		sprite.get_child(0).play("drake-fly")

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
		fire_boll()
	elif moveid == 3:
		bite()

func idle_fly():
	print("Flying")

func tail_attack():
	print("Tail Attack")

func fire_boll():
	print("Fire Boll")

func bite():
	print("Bite")

