extends KinematicBody2D

const FRICTION = 700
const ACCELERATION = 700
const MAX_SPEED = 20
onready var playerDriftZone = $PlayerDriftZone
onready var playerDriftZoneCollision = $PlayerDriftZone/CollisionShape2D
onready var pickUpZone = $PickUpZone
onready var pickUpCollision = $PickUpZone/CollisionShape2D
onready var spriteIcon = $Icon
onready var softCollision = $SoftCollision
onready var ItemDB = get_node("../../ItemDB")
onready var animationPlayer = $AnimationPlayer
export(Resource) var item
var velocity = Vector2.ZERO
var seek_player = false
var spawned_on_player = false
var available = false
var inventory = preload("res://Inventory.tres")
const POOF = preload("res://Effects/Poof.tscn")

func _ready():
	spriteIcon.texture = item.icon
	
func _process(delta):
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector().normalized()
	else:
		velocity = Vector2.ZERO
#	if seek_player && available:
#		velocity += global_position.direction_to(playerDriftZone.player.global_position)
#		velocity = velocity.normalized()
#		if velocity != Vector2.ZERO:
#			velocity = velocity.move_toward(velocity * MAX_SPEED, ACCELERATION * delta)
#		else:
#			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)

func _on_PlayerDriftZone_drift_started():
	seek_player = true

func _on_PlayerDriftZone_drift_ended():
	seek_player = false
	velocity = Vector2.ZERO

func _on_PickUpZone_pickup_ended():
	available = true

func _on_PickUpZone_pickup_started():
	var free_index = inventory.items.find(null)
	if free_index != -1 && available:
		inventory.set_item(free_index, item, "INVENTORY")
		var poof_instance = POOF.instance()
		poof_instance.global_position = global_position + Vector2(0, -8)
		get_parent().add_child(poof_instance)
		queue_free()
