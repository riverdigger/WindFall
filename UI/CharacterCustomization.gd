extends Node2D

const composite_sprites = preload("res://UI/CompositeSprites.gd")

onready var bodySprite = $CompositeSprites/Body
onready var eyesSprite = $CompositeSprites/Eyes
onready var hairSprite = $CompositeSprites/Hair
onready var topSprite = $CompositeSprites/Top

var curr_hair: int = 0
var curr_eyes: int = 0
var curr_top: int = 0
var rng = RandomNumberGenerator.new()
var bodyMod: float = 0.0 # Keeps track of body color brightness modifier
var eyesMod: float = 0.0 # Keeps track of eye color hue modifier

func _ready():
	bodySprite.texture = composite_sprites.body_spritesheet[0]
	eyesSprite.texture = composite_sprites.eyes_spritesheet[curr_eyes]
	hairSprite.texture = composite_sprites.hair_spritesheet[curr_hair]
	topSprite.texture = composite_sprites.top_spritesheet[curr_top]
	
	bodySprite.get_material().set_shader_param("bodyMod", bodyMod)
	eyesSprite.get_material().set_shader_param("eyesMod", eyesMod)

func _on_HairNext_pressed():
	curr_hair = (curr_hair + 1) % composite_sprites.hair_spritesheet.size()
	hairSprite.texture = composite_sprites.hair_spritesheet[curr_hair]	

func _on_HairPrev_pressed():
	curr_hair -= 1
	if curr_hair < 0:
		curr_hair = composite_sprites.hair_spritesheet.size() - 1
	hairSprite.texture = composite_sprites.hair_spritesheet[curr_hair]	

func _on_EyesNext_pressed():
	curr_eyes = (curr_eyes + 1) % composite_sprites.eyes_spritesheet.size()
	eyesSprite.texture = composite_sprites.eyes_spritesheet[curr_eyes]	

func _on_EyesPrev_pressed():
	curr_eyes -= 1
	if curr_eyes < 0:
		curr_eyes = composite_sprites.eyes_spritesheet.size() - 1
	eyesSprite.texture = composite_sprites.eyes_spritesheet[curr_eyes]	

func _on_Randomize_pressed():
	curr_eyes = rng.randi_range(0, composite_sprites.eyes_spritesheet.size() - 1)
	curr_hair = rng.randi_range(0, composite_sprites.hair_spritesheet.size() - 1)
	curr_top = rng.randi_range(0, composite_sprites.top_spritesheet.size() - 1)
	
	eyesSprite.texture = composite_sprites.eyes_spritesheet[curr_eyes]	
	hairSprite.texture = composite_sprites.hair_spritesheet[curr_hair]	
	topSprite.texture = composite_sprites.top_spritesheet[curr_top]	
	
	bodyMod = rng.randf_range(-0.6, 0.3) # good skin color range
	eyesMod = rng.randf()
	
	bodySprite.get_material().set_shader_param("bodyMod", bodyMod)	
	eyesSprite.get_material().set_shader_param("eyesMod", eyesMod)	
