extends Node2D

onready var animatedSprite = $AnimatedSprite

func _ready():
	show()

func hide():
	animatedSprite.play("Hidden")

func show():
	animatedSprite.play("Animation")
