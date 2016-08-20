
extends Label

export var anim_node = ""
export var animation = ""
export var prefix = ""
export var sulffix = ""

func _ready():
	.set_opacity(0)
	

func hit(hit_num):
	.set_text(prefix+ " %s " % hit_num +sulffix)
	.get_node(anim_node).play(animation)

