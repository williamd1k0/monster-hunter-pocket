extends Node

signal on_attacked

func _ready():
	print("A wild drake appears!")
	set_process(true)
