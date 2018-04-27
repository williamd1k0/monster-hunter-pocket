extends Area2D

const idle_damage = 5
var current_attack = 0



func get_damage():
	if current_attack == 0:
		return idle_damage
