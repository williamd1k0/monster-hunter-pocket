extends KinematicBody2D

signal life_change(percent)
signal damage(force)
signal died

export(bool) var crouching = false

onready var hurt_box = get_node("HurtBox")
onready var hit_box = get_node("HitBox")
onready var anime = get_node("AnimationPlayer")
onready var particles = get_node("HitBox/CollisionShape2D/Particles2D")

var life = 100
var total_life = life
var delta_acc = 0
var speed_inc = 2
var locked = false
var shield_up = false

var idle_delay = 0.0

func _ready():
	#hit_box.set_enable_monitoring(false)
	set_process(true)
	set_process_input(true)

func _process(delta):
	move(Vector2(0, 0))
	if not locked:
		process_movement(delta)

func _input(event):
	process_actions(event)

func lock_player():
	locked = true

func unlock_player():
	play_once("idle")
	locked = false

func process_actions(event):
	if not locked and event.is_action_pressed("player_atk"):
		process_attack()
	elif event.is_action_pressed("player_def"):
		process_shield()
	if event.is_action_released("player_def"):
		release_shield()

func process_shield():
	print("Player DEF BEGIN")
	lock_player()
	shield_up = true
	anime.play('shield')
	#yield(anime, 'finished')
	#shield_up = false
	#unlock_player()
	#print("Player DEF END")

func release_shield():
	print("Player DEF END")
	shield_up = false
	unlock_player()
	play_once('idle')

func process_attack():
	print("Player ATK BEGIN")
	lock_player()
	hit_box.set_monitorable(true)
	hit_box.set_enable_monitoring(true)
	anime.play("attack")
	yield(anime, 'finished')
	unlock_player()
	hit_box.set_monitorable(false)
	hit_box.set_enable_monitoring(false)
	print("Player ATK END")

func play_once(anim):
	if anime.get_current_animation() != anim or not anime.is_playing():
		anime.play(anim)

func process_movement(delta):
	# NOTE: testing movement using accumulated delta
	delta_acc += delta
	if float(delta_acc*100) < get_speed_inc():
		return
	delta_acc = 0
	var movement = Vector2(0, 0)
	if Input.is_action_pressed("ui_right"):
		movement = Vector2(1, 0)
	elif Input.is_action_pressed("ui_left"):
		movement = Vector2(-1, 0)
	if movement == Vector2(0, 0):
		idle_delay += delta
		if idle_delay >= .15:
			idle_delay = 0.0
			play_once("idle")
			reset_speed_inc()
	else:
		set_mirrored(not(movement.x+1)) # Hacking to the gate
		play_once("run")
		move(movement)
		idle_delay = 0.0

func set_mirrored(mirror):
	if mirror:
		set_scale(Vector2(-1, 1))
	else:
		set_scale(Vector2(1, 1))

func get_speed_inc():
	speed_inc -= .1
	return speed_inc

func reset_speed_inc():
	speed_inc = 3

func apply_damage(force):
	life = max(0, life-force)
	emit_signal('life_change', life * total_life / 100)

func _on_HurtBox_area_enter(area):
	if area.is_in_group('wyvern-hit'):
		# XXX
		if not shield_up:
			prints("FELYNE HURT by", area, area.get_damage())
			apply_damage(area.get_damage())

func _on_HitBox_area_enter( area ):
	if area.is_in_group('wyvern-body'):
		print('WYVERN')
		particles.set_emitting(true)
