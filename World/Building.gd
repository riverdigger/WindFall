extends StaticBody2D

onready var sceneTransitionRect = get_node("../../GUIController/SceneTransitionRect")
export(Vector2) var player_spawn_location = Vector2.ZERO

func _on_DoorZone_zone_entered(scene_path):
	Global.player_spawn_position = player_spawn_location
	sceneTransitionRect.animationPlayer.play("Fade")
	sceneTransitionRect.transition_to(scene_path)

func _on_DoorZone_zone_exited(scene_path):
	sceneTransitionRect.animationPlayer.play_backwards("Fade")
