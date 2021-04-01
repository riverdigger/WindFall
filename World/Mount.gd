extends KinematicBody2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var player = get_node("../Player")
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var stats = $MountStats
onready var mySprite = $Sprite
export var show_vectors = false
var circle_pos = Vector2.ZERO
var radian = 0
var key_bubble_instance
var state = IDLE
var rng = RandomNumberGenerator.new()
var velocity = Vector2.ZERO
const DUST = preload("res://Effects/Dust.tscn")


# STATES
enum {
	IDLE,
	WANDER,
	MOVE
}

# Called when the node enters the scene tree for the first time.
func _ready():
	animationTree.active = true

func _physics_process(delta):
	update()
	var direction = stats.target
	match state:
		IDLE:
			direction = Vector2.ZERO
			if stats.mounted:		
				animationTree.set("parameters/Idle/blend_position", mySprite.scale)
				animationState.travel("Idle")
			else:
				animationTree.set("parameters/FreeIdle/blend_position", mySprite.scale)
				animationState.travel("FreeIdle")
			detect_player()
			seek(direction, delta)
		WANDER:
			detect_player()
			seek(direction, delta)
		MOVE:
			move_state(delta)

func move_state(delta):
	if Input.is_action_just_pressed("interact"):
		player.dismount(self)

func seek(input_vector, delta):
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if stats.mounted:
			animationTree.set("parameters/FreeIdle/blend_position", input_vector)
		else:
			animationTree.set("parameters/Idle/blend_position", input_vector)
			animationTree.set("parameters/Run/blend_position", input_vector)
		
		velocity = velocity.move_toward(input_vector * stats.MAX_SPEED, stats.ACCELERATION * delta)
		
		if !stats.hasDust:
			var dust_instance = DUST.instance()
			get_parent().add_child(dust_instance)
			dust_instance.global_position = self.global_position
			if input_vector.x < 0:
				dust_instance.get_node("AnimationPlayer").play("PoofRight")
			stats.hasDust = true
		if stats.mounted:		
			animationState.travel("Run")
		else:
			pass
	else:
		if stats.mounted:		
			animationState.travel("Idle")
		else:
			animationState.travel("FreeIdle")
		velocity = velocity.move_toward(Vector2.ZERO, stats.FRICTION * delta)
	
		
	velocity = move_and_slide(input_vector * stats.MAX_SPEED)
	
	if velocity == Vector2.ZERO:
		stats.hasDust = false

func _on_Timer_timeout():
	# Smooth Turn Wander
	circle_pos = global_position + velocity.normalized() * stats.WANDER_RING_DISTANCE
	radian = rng.randi_range(0,360) * PI / 180
	stats.target = (circle_pos - global_position) + Vector2(stats.WANDER_RING_RADIUS, 0).rotated(radian)

func detect_player():
	if playerDetectionZone.can_see_player() && PlayerStats.can_interact && self == player.closest_interaction():
		if key_bubble_instance == null:
			var KeyBubble = load("res://UI/KeyBubble.tscn")
			key_bubble_instance = KeyBubble.instance()
			add_child(key_bubble_instance)
			key_bubble_instance.global_position = $InteractKeyAttachPoint.global_position
		if Input.is_action_just_pressed("interact"):
			player.mount(self)
	else:
		if key_bubble_instance != null:
			key_bubble_instance.hide()

func _on_PlayerDetectionZone_interact_started():
	player.add_to_pool(self)

func _on_PlayerDetectionZone_interact_ended():
	player.remove_from_pool(self)
	if key_bubble_instance != null:
		key_bubble_instance.queue_free()
