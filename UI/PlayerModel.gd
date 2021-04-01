extends Node2D

var inventory = preload("res://Inventory.tres")

onready var compositeSprites = $CompositeSprites
onready var animationPlayer = $CompositeSprites/AnimationPlayer
onready var animationTree = $CompositeSprites/AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var guiController = get_parent().get_parent().get_parent()
onready var player = get_node("../../../../YSort/Player")
onready var bodySprite = $CompositeSprites/Body
onready var eyesSprite = $CompositeSprites/Eyes
onready var hairSprite = $CompositeSprites/Hair
onready var hairbackSprite = $CompositeSprites/HairBack

var stats = PlayerStats

func _ready():
	guiController.connect("inventory_modal_changed", self, "_on_inventory_modal_changed")
	player.connect("refresh_player_model", self, "_on_refresh_player_model")
	
func _on_refresh_player_model(sprites):
	for child in get_children():
		remove_child(child)
	var new_child = sprites
	add_child(new_child)
	new_child.global_position = global_position
	
func _on_inventory_modal_changed(modal_state):
	if modal_state:
		animationTree.active = true
		animationTree.set("parameters/Idle/blend_position", Vector2.ZERO)
		animationState.travel("Idle")
		_on_refresh_player_model(player.get_child(2).duplicate())
