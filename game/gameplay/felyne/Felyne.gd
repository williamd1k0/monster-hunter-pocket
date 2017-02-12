extends KinematicBody2D

signal life_change(percent)
signal died

var life = 100
var total_life = life
var delta_acc = 0
var speed_inc = 2

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	process_movement(delta)

func process_movement(delta):
	# NOTE: testing movement using accumulated delta
	delta_acc += delta
	if float(delta_acc*100) < get_speed_inc():
		return
	delta_acc = 0
	if Input.is_action_pressed("ui_right"):
		get_node("Sprite").set_flip_h(false)
		move(Vector2(2, 0))
	elif Input.is_action_pressed("ui_left"):
		get_node("Sprite").set_flip_h(true)
		move(Vector2(-2, 0))
	else:
		reset_speed_inc()

func get_speed_inc():
	speed_inc -= .1
	return speed_inc

func reset_speed_inc():
	speed_inc = 3

func apply_damage(force):
	life -= force
	emit_signal('life_change', life * total_life / 100)
