
extends Node

export var life = 0
var initial_life = 0
var direction = null
var initial_direction = null
var dead = false
var won = false
var sprite = null
var flip = null

signal on_dead
signal on_win

func _ready():
	initial_life = life

func is_dead():
	return life <= 0

func is_busy():
	pass
	
func play_animation():
	if direction == initial_direction:
		flip = false
	else:
		flip = true
	if sprite.is_flipped_h() != flip:
		sprite.set_flip_h(flip)

func set_life(lf):
	life = lf

func set_initial_direction(dir):
	if dir == "right":
		initial_direction = true
	else:
		initial_direction = false
	direction = initial_direction

func toggle_direction():
	direction = not direction

func get_direction():
	if direction:
		return "right"
	else:
		return "left"