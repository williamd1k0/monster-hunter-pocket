
extends Label

export var anim_node = ""
export var animation = ""
export var prefix = ""
export var sulffix = ""
export var x_add = 0
export var y_add = 0

func _ready():
	.set_opacity(0)
	

func hit(hit_num, vec):
	.set_text(prefix+ " %s " % hit_num +sulffix)
	.set_pos(Vector2(vec.x+x_add, vec.y+y_add))
	.get_node(anim_node).play(animation)

