extends Area2D

var player = null
signal pickup_started
signal pickup_ended

func can_see_player():
	return player != null

func _on_PickUpZone_body_entered(body):
	player = body
	emit_signal("pickup_started")
	
func _on_PickUpZone_body_exited(body):
	player = null
	emit_signal("pickup_ended")
