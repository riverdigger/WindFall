extends Area2D

export(String, FILE) var door_scene = ""
var player = null
signal zone_entered(scene_path)
signal zone_exited(scene_path)

func can_see_player():
	return player != null

func _on_DoorZone_body_entered(body):
	player = body
	emit_signal("zone_entered", door_scene)
	
func _on_DoorZone_body_exited(body):
	player = null
	emit_signal("zone_exited", door_scene)
