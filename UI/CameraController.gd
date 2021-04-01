extends Node2D

onready var mainCamera = $MainCamera
onready var remoteTransform = get_node("../YSort/Player/RemoteTransform2D")
var current_focus = Vector2.ZERO
var focusQueue = []

# We store a reference to the scene's tween node.
onready var tween: Tween = $Tween
onready var player = get_node("../YSort/Player")

func _ready():
	focusQueue.push_back(player)
	current_focus = player.global_position
	focus_on_front()

func request_focus(object):
	focusQueue.push_back(object)
	if focusQueue.front() == player:
		focusQueue.pop_front()
		focus_on_front()

func focus_on_front():
	var new_focus = focusQueue.front().global_position
	if new_focus == player.global_position:
		PlayerStats.can_interact = true
		mainCamera._set_zoom_level(mainCamera.max_zoom)			
	else:
		PlayerStats.can_interact = false
		mainCamera._set_zoom_level(mainCamera.min_zoom)	
	remoteTransform.global_position = new_focus
		
func abandon_focus(object):
	var place_in_line = focusQueue.find(object, 0)
	if place_in_line != -1:
		focusQueue.remove(place_in_line)
#
	if focusQueue.size() == 0:
		focusQueue.push_back(player)
#
	focus_on_front()
