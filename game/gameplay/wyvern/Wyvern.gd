extends KinematicBody2D

enum {
	S_MOVING=1<<0,
	S_FIREBALL=1<<1,
	S_BITE=1<<2,
	S_DASH_START=1<<3,
	S_DASH_END=1<<4
}

export(bool) var debug = false
const ATTACKING = 0 | S_FIREBALL | S_BITE | S_DASH_START | S_DASH_END
const attacks = {
	'aerial': ['null', 'dash'],
	'ground': ['null']
}

onready var tween = get_node("Tween")
onready var initial_pos = get_pos()
onready var floor_pos = initial_pos + Vector2(0, 32)
var attack_acc = 0
var attack_wait = 5
var state = 0
var pos_names = ['aerial', 'ground']

func _ready():
	set_process(true)

func _process(delta):
	move(Vector2(0, 0)) # force collision check
	return
	var will_toggle_pos = not (randi() % 100) # 100 false / 1 true
	if not is_attacking():
		if will_toggle_pos:
			toggle_position()
		else:
			process_attack(delta)

func process_attack(delta):
	attack_acc += delta
	if int(attack_acc) >= attack_wait:
		prints(attack_wait, 'seconds')
		attack_wait = randi() % 5
		attack_acc = 0
		call('attack_' + attacks[pos_names[0]][randi() % attacks[pos_names[0]].size()])

func toggle_position():
	print('TOGGLE POS')
	state |= S_MOVING
	# play animation/tween
	pos_names.invert()
	state &= ~S_MOVING

func attack_null():
	print('NULL ACTION')

func attack_dash():
	print('DASH ACTION')
	if not state & S_DASH_START:
		tween.interpolate_method(
			self,
			'_process_dash',
			initial_pos,
			floor_pos,
			2.0,
			Tween.TRANS_ELASTIC,
			Tween.EASE_IN
		)
		state |= S_DASH_START
	else:
		tween.interpolate_method(
			self,
			'_process_dash',
			floor_pos,
			initial_pos,
			3.0,
			Tween.TRANS_EXPO,
			Tween.EASE_OUT
		)
		state &= ~S_DASH_START
		state |= S_DASH_END
	tween.start()

func _process_dash(movement):
	set_pos(movement)

func is_attacking():
	return state & ATTACKING

func _on_HurtBox_area_enter( area ):
	print(area)

func _on_tween_complete( object, key ):
	if key == '_process_dash':
		if state & S_DASH_START:
			attack_dash()
		else:
			state &= ~S_DASH_END

