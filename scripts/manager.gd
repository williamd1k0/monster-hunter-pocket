extends Node

func _ready():
	print("Initializing!")
	Globals.set("start_game", true)
	if not Globals.has("max_score"):
		Globals.set("max_score", 0)
	Globals.save()

func _on_Timer_timeout():
	get_tree().change_scene("res://scenes/Disclaimer.tscn")
