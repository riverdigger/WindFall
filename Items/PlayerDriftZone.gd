extends Area2D

var player = null
signal drift_started
signal drift_ended

func can_see_player():
	return player != null

func _on_PlayerDriftZone_body_entered(body):
	player = body
	emit_signal("drift_started")
	
func _on_PlayerDriftZone_body_exited(body):
	player = null
	emit_signal("drift_ended")
