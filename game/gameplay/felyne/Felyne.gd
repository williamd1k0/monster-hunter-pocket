extends KinematicBody2D

signal life_change(percent)
signal damage(force)
signal died

const HURT_LAYER = 2
const HIT_LAYER = 4

onready var hurt_box = get_node("Body/HurtBox")
onready var hit_box = get_node("Body/HitBox")
onready var anime = get_node("AnimationPlayer")

var life = 100
var total_life = life
var delta_acc = 0
var speed_inc = 2
var locked = false

func _ready():
	hit_box.set_layer_mask(0)
	print(hurt_box.get_layer_mask())
	print(hit_box.get_layer_mask())
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	if not locked:
		process_movement(delta)

func _input(event):
	if not locked:
		process_actions(event)

func lock_player():
	locked = true

func unlock_player():
	locked = false

func process_actions(event):
	if event.is_action_pressed("player_atk"):
		process_attack()
	elif event.is_action_pressed("player_def"):
		process_defense()

func process_defense():
	print("Player DEF BEGIN")
	lock_player()
	hurt_box.set_layer_mask(0)
	anime.play('defense')
	yield(anime, 'finished')
	hurt_box.set_layer_mask(HURT_LAYER)
	unlock_player()
	print("Player DEF END")

func process_attack():
	print("Player ATK BEGIN")
	lock_player()
	hit_box.set_layer_mask(HIT_LAYER)
	anime.play("attack")
	yield(anime, 'finished')
	hit_box.set_layer_mask(0)
	unlock_player()
	print("Player ATK END")

func process_movement(delta):
	# NOTE: testing movement using accumulated delta
	delta_acc += delta
	if float(delta_acc*100) < get_speed_inc():
		return
	delta_acc = 0
	if Input.is_action_pressed("ui_right"):
		get_node("Body").set_scale(Vector2(1, 1))
		move(Vector2(2, 0))
	elif Input.is_action_pressed("ui_left"):
		get_node("Body").set_scale(Vector2(-1, 1))
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

func _on_HurtBox_area_enter(area):
	pass # replace with function body
