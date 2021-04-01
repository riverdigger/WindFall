extends Node

export(int) var curr_body = 0
export(int) var curr_hair = 0
export(int) var curr_eyes = 0
export(int) var curr_bottom = 0
export(int) var curr_top = 0
export(int) var curr_shoes = 0
export(int) var curr_hat = 0
export(int) var curr_cape = 0
export var curr_tuck: bool = true
export(Resource) var HatItem
export(Resource) var TopItem
export(Resource) var BottomItem
export(Resource) var ShoesItem
export(Resource) var CapeItem
export var age: float = rand_range(18.0, 100.0)
export var bodyMod: float = 0.0 # Keeps track of body color brightness modifier
export var eyesMod: float = 0.0 # Keeps track of eye color hue modifier
export var hasDust: bool = false
export var can_interact: bool = true
export var interactPool = []
export var target = Vector2.ZERO
export var FRICTION = 500
export var ACCELERATION = 500
export var MAX_SPEED = 120
export var DEFAULT_MAX_SPEED = 120
export var RUN_SPEED = 120 # When run animation should start playing
export var WANDER_RING_DISTANCE = 75
export var WANDER_RING_RADIUS = 25
var mount = null
var path = [] setget set_path
var position_reached = true

signal item_equipped(item, item_type)

#func _ready():
#	set_process(false)

func equip_item(item, item_type):
	match item_type:
		"HAT":
			HatItem = item
		"TOP":
			TopItem = item
		"BOTTOM":
			BottomItem = item
		"SHOES":
			ShoesItem = item
		"CAPE":
			CapeItem = item
	emit_signal("item_equipped", item, item_type)

func set_path(value):
	path = value
	if path.size() == 0:
		position_reached = true
	else:
		position_reached = false
