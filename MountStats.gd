extends Node

export var bodyMod: float = 0.0 # Keeps track of body color brightness modifier
export var eyesMod: float = 0.0 # Keeps track of eye color hue modifier
export var hasDust: bool = false
export var can_interact: bool = true
export var interactPool = []
export var target = Vector2.ZERO
export var FRICTION = 500
export var ACCELERATION = 500
export var MAX_SPEED = 120
export var RUN_SPEED = 120 # When run animation should start playing
export var WANDER_RING_DISTANCE = 75
export var WANDER_RING_RADIUS = 25
var mounted = false
