extends Area2D

onready var sceneTransitionRect = get_node("../GUIController/SceneTransitionRect")
export(Vector2) var player_spawn_location = Vector2.ZERO
export(String, FILE) var door_scene = ""

func _on_ExitZone_body_entered(body):
	Global.player_spawn_position = player_spawn_location
	sceneTransitionRect.animationPlayer.play("Fade")
	sceneTransitionRect.transition_to(door_scene)


func _on_ExitZone_body_exited(body):
	sceneTransitionRect.animationPlayer.play_backwards("Fade")
