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

onready var tween = get_node("Tween")
onready var initial_pos = get_pos()
onready var floor_pos = initial_pos + Vector2(0, 32)
var updown_acc = 0
var state = 0

func _ready():
	set_process(true)

func _process(delta):
	move(Vector2(0, 0)) # force collision check
	if not is_attacking():
		updown_acc += delta
	if int(updown_acc) >= 5:
		print('5s')
		updown_acc = 0
		process_dash()

func process_dash():
	if not state & S_DASH_START:
		tween.interpolate_method(
			self,
			'_process_dash',
			initial_pos,
			floor_pos,
			3.0,
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
			process_dash()
		else:
			state &= ~S_DASH_END

