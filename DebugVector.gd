extends Control

func _ready():
	set_process(true)

func _process(delta):
	update()

func _draw():
#	draw_line($NPC.global_position, get_parent().stats.target, Color(255, 0, 0), 5)
	draw_line(get_parent().get_global_position(), get_parent().get_global_position() + Vector2(1,1), Color(0, 255, 0), 5)
	print(get_parent().stats.target)
