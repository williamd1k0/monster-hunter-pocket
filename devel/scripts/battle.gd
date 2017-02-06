
extends Node

var game_end = false
var gameover = null
var gameover_text = "GAME OVER"
var winner_text = "Quest completed!\nThank you for playing"

signal on_gameover(winner)

func _ready():
	gameover = get_child(4)
	set_process_input(true)

func _input(event):
	if game_end and not gameover.get_child(1).get_child(0).get_child(0).is_playing():
		if event.is_action("one_button"):
			get_tree().change_scene("res://scenes/Splash.tscn")

func _on_BattleScene_on_gameover(winner):
	gameover.get_child(0).show()
	gameover.get_child(0).get_child(0).play("dotted-fadeout")
	if winner == "drake":
		get_child(2).get_child(0).set_z(4)
		gameover.get_child(1).get_child(0).set_text(gameover_text)
	else:
		get_child(1).get_child(0).set_z(4)
		gameover.get_child(1).get_child(0).set_text(winner_text)
	gameover.get_child(1).get_child(0).show()
	gameover.get_child(1).get_child(0).get_child(0).play("fadein")
	game_end = true
