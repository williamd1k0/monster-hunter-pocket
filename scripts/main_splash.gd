extends Node

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)

func _input(event):
	if event.is_action("one_button"):
		print("Changing scene...")
		get_tree().change_scene("res://scenes/Main.tscn")


