extends Node

var read = false

func _ready():
	get_child(0).get_child(0).set_opacity(0)

func _on_Timer_timeout():
	print("Changing scene...")
	read = true
	get_child(0).get_child(0).get_child(0).play("fadeout")


func _on_AnimationPlayer_finished():
	if read:
		get_tree().change_scene("res://scenes/Splash.tscn")
