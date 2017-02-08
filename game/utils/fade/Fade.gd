extends Control

signal fadein
signal fadeout

export(bool) var show_ = false setget _set_show


func _ready():
	pass

func _set_show(val):
	show_ = val
	if val:
		print('Fade-in')
	else:
		print('Fade-out')