extends Area2D

var player = null
signal interact_started
signal interact_ended

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body
	emit_signal("interact_started")
	
func _on_PlayerDetectionZone_body_exited(body):
	player = null
	emit_signal("interact_ended")
