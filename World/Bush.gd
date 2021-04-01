extends StaticBody2D

var can_interact = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Hurtbox_area_entered(area):
	queue_free()
