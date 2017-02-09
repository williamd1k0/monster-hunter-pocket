tool
extends Control

# Simple wrapper for ColorFrame node (2.2)

export(Color) var color = Color(1, 1, 1)

func _ready():
	pass

func draw_frame():
	draw_rect(Rect2(get_node("Position2D").get_pos(), get_size()), color)

func _draw():
	draw_frame()
