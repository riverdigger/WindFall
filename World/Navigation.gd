extends Node2D

onready var navigation2D : Navigation2D = $Navigation2D
onready var line2D : Line2D = $Line2D
onready var navTileMap = $Navigation2D/NavTileMap
onready var player = get_node("../YSort/Player")
onready var npc = get_node("../YSort/NPCs/NPC")
onready var npcs = get_node("../YSort/NPCs")

var event_global_position

func _ready():
	navTileMap.visible = false

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return

	event_global_position = get_global_mouse_position()
#	line2D.points = new_path
	for child in npcs.get_children():
		var new_path = navigation2D.get_simple_path(child.global_position, get_global_mouse_position())
		child.stats.path = Array(new_path)
