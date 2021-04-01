extends Node2D

const IMPACT = preload("res://Effects/RainImpact.tscn")
onready var rainScreenColor = $RainScreenColor
onready var ysortNode = get_node("../../YSort")
onready var cameraControllerNode = get_node("../../YSort/Player")
var fade_out = false
var fade_in = false
export var enabled = false

func _ready():
	if enabled:
		set_modulate(Color(1,1,1,0.0))

func _process(delta):
	if enabled:
		if randi() % 2 == 0 && visible && !fade_out:
			var rain_instance = IMPACT.instance()
			ysortNode.add_child(rain_instance)
			rain_instance.global_position = cameraControllerNode.global_position - Vector2(randi() % int(rainScreenColor.get_viewport_rect().size.x / 2), randi() % int(rainScreenColor.get_viewport_rect().size.y / 2)) + Vector2(randi() % int(rainScreenColor.get_viewport_rect().size.x), randi() % int(rainScreenColor.get_viewport_rect().size.y))
		if fade_out:
			var lerp_amount = lerp(get_modulate(), Color(1,1,1,0), 0.01)
			set_modulate(lerp_amount)
			if lerp_amount.a <= 0.0001:
				visible = false
				fade_out = false
				fade_in = false
		elif fade_in:
			visible = true
			set_modulate(lerp(get_modulate(), Color(1,1,1,1.0), 0.01))

func _on_Timer_timeout():
	if enabled:
		if visible:
			fade_out = true
			fade_in = false
		else:
			fade_in = true
			fade_out = false
