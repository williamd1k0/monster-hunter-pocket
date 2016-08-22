extends Node

var is_ready = false
var begin_game = false
var read_inst = false
var lock_input = false
var title = null
var drake = null
var nyan = null
var inst = null

func _ready():
	set_process_input(true)
	title = get_child(0)
	drake = get_child(1).get_child(0)
	nyan = get_child(2).get_child(0)
	inst = get_child(3)
	
	drake.get_child(0).play("drake-fly-r")
	drake.get_child(1).play("r2l")

func _input(event):
	print(lock_input)
	if event.is_action("one_button") and not lock_input:
		if is_ready and not begin_game:
			print("Changing scene...")
			begin_game = true
			title.get_child(1).get_child(0).play("dotted-fadout")
			lock_input = true
		elif begin_game:
			read_inst = true
			inst.get_child(1).get_child(0).play("dotted-fadout")


func _on_Timer_timeout():
	is_ready = true

func _on_AnimationPlayer_2_finished():
	nyan.get_child(1).play("nyan-run-r")
	nyan.get_child(0).play("l2r")

func _on_AnimationPlayer_finished():
	title.get_child(1).get_child(0).play("dotted-fadein")
	title.get_child(0).get_child(0).play("blink")


func _on_Text_AnimationPlayer_finished():
	if begin_game:
		inst.get_child(1).show()
		inst.get_child(1).get_child(0).play("dotted-fadein")
		inst.get_child(0).show()
		get_child(6).start()


func _on_Timer_2_timeout():
	inst.get_child(1).get_child(0).play("dotted-fadout")
	get_child(7).start()


func _on_Timer_3_timeout():
	get_tree().change_scene("res://scenes/Main.tscn")
