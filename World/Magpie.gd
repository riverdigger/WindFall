extends KinematicBody2D

# STATES
enum {
	IDLE,
	WANDER,
	RETURN
}
var start_pos
var state = IDLE
var circle_pos = Vector2.ZERO
var radian = 0
var rng = RandomNumberGenerator.new()
var velocity = Vector2.ZERO
export var target = Vector2.ZERO
export var FRICTION = 500
export var ACCELERATION = 500
export var MAX_SPEED = 120
export var DEFAULT_MAX_SPEED = 120
export var RUN_SPEED = 120 # When run animation should start playing
export var WANDER_RING_DISTANCE = 75
export var WANDER_RING_RADIUS = 25
onready var wanderTimer = $WanderTimer
onready var animatedSprite = $AnimatedSprite
onready var timer = $Timer
onready var playerDetectionZone = $PlayerDetectionZone

func is_colliding():
	var areas = playerDetectionZone.get_overlapping_areas()
	print(areas)
	return areas.size() > 0
	
func get_push_vector():
	var areas = playerDetectionZone.get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		for area in areas:
			var distance = area.global_position.distance_to(global_position) + 0.001
			push_vector = (push_vector + area.global_position.direction_to(global_position)) / 2
	return push_vector

func _ready():
	$AnimatedSprite.frame = int(ceil(rand_range(0, $AnimatedSprite.frames.get_frame_count("Animation"))))
	MAX_SPEED = rng.randi_range(200, 220)
	DEFAULT_MAX_SPEED = MAX_SPEED
	start_pos = global_position
	
func _physics_process(delta):
	var direction = target
	match state:
		IDLE:
			z_index = 0
			direction = Vector2.ZERO
			animatedSprite.play("Idle")
		WANDER:
			pass
		RETURN:
			target = global_position.direction_to(start_pos)
			if global_position.distance_to(start_pos) < 5.0:
				state = IDLE
				target = Vector2.ZERO
				direction = Vector2.ZERO
	seek(direction, delta)

func seek(input_vector, delta):
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
#		animationTree.set("parameters/Idle/blend_position", input_vector)
#		animationTree.set("parameters/Walk/blend_position", input_vector)
#		animationTree.set("parameters/Run/blend_position", input_vector)
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
		animatedSprite.play("Flying")
	else:
		animatedSprite.play("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
	if velocity.x < 0:
		animatedSprite.scale = Vector2(1, 1)
	else:
		animatedSprite.scale = Vector2(-1, 1)		
	
func _on_PlayerDetectionZone_interact_started():
	state = WANDER
	z_index = 1
	target = (playerDetectionZone.player.global_position.direction_to(global_position))
	wanderTimer.start(0.5)
	timer.start(5)

func _on_WanderTimer_timeout():
	# Smooth Turn Wander
	if state == WANDER:
		circle_pos = global_position + velocity.normalized() * WANDER_RING_DISTANCE
		radian = rng.randi_range(0,360) * PI / 180
		target = (circle_pos - global_position) + Vector2(WANDER_RING_RADIUS, 0).rotated(radian)

func _on_Timer_timeout():
	target = global_position.direction_to(start_pos)
	state = RETURN
