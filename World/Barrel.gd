extends RigidBody2D

onready var animatedSprite = $AnimatedSprite

func _ready():
	pass

func _process(delta):
	if linear_velocity.length() > 0:
		animatedSprite.play()
		animatedSprite.speed_scale = linear_velocity.length() * 0.1
		if animatedSprite.speed_scale > 1.0:
			animatedSprite.speed_scale = 1.0
	else:
		animatedSprite.stop()
	
	if linear_velocity.x < 0:
		scale.x = 1.0
	else:
		scale.x = -1.0
