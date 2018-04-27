extends Control

export(float) var initial_value = 100

onready var life_frame = get_node("LifeFrame")
onready var life_size = life_frame.get_size()
onready var tween = get_node("Tween")

func _ready():
	update_bar(initial_value)

func update_bar(percent):
	tween.interpolate_method(
		self, '_update_bar',
		life_frame.get_size().x/life_size.x*100, percent,
		1, Tween.TRANS_BOUNCE, Tween.EASE_OUT
	)
	tween.start()

func _update_bar(percent):
	life_frame.set_size(Vector2(life_size.x * percent / 100, life_size.y))
