# https://www.gdquest.com/tutorial/godot/2d/scene-transition-rect/
extends ColorRect

# Path to the next scene to transition to
export(String, FILE, "*.tscn") var next_scene_path

# Reference to the _AnimationPlayer_ node
onready var animationPlayer = $AnimationPlayer

func _ready():
	# Plays the animation backward to fade in
	visible = true
	animationPlayer.play_backwards("Fade")

func transition_to(_next_scene := next_scene_path):
	print(_next_scene)
	if _next_scene != "res://World/World.tscn":
		yield(Global.save_game(), "completed")
	# Plays the Fade animation and wait until it finishes
	animationPlayer.play("Fade")
	yield(animationPlayer, "animation_finished")
	PlayerStats.interactPool = []
	get_tree().change_scene(_next_scene)
