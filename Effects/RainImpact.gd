extends AnimatedSprite

func _ready():
	play("default")

func _on_RainImpact_animation_finished():
	queue_free()
