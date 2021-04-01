extends KinematicBody2D

# PLAYER VARS
export var show_vectors = false
export var smooth = 0.01
const DUST = preload("res://Effects/Dust.tscn")

var velocity = Vector2.ZERO
var stats = PlayerStats
var composite_sprites = CompositeSprites
var rng = RandomNumberGenerator.new()
var mount_collision
var just_mounted = true

# STATES
enum {
	MOVE,
	SAD,
	TALKING,
	INVENTORY,
	MOUNTED
}

var state = MOVE
var prev_state = MOVE

# OUTFITS
onready var bodySprite = $CompositeSprites/Body
onready var eyesSprite = $CompositeSprites/Eyes
onready var hairSprite = $CompositeSprites/Hair
onready var hairbackSprite = $CompositeSprites/HairBack
onready var bottomSprite = $CompositeSprites/Bottom
onready var topSprite = $CompositeSprites/Top
onready var shoesSprite = $CompositeSprites/Shoes
onready var hatSprite = $CompositeSprites/Hat
onready var hatbackSprite = $CompositeSprites/HatBack
onready var capeSprite = $CompositeSprites/Cape
onready var capebackSprite = $CompositeSprites/CapeBack
onready var mySprites = $CompositeSprites

# NODES
onready var softCollision = $SoftCollision
onready var cameraController = get_node("../../CameraController")
onready var animationPlayer = $CompositeSprites/AnimationPlayer
onready var animationTree = $CompositeSprites/AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var guiController = get_node("../../GUIController")

signal refresh_player_model(sprites)

func _ready():
	global_position = Global.player_spawn_position
	Global.player = self
	guiController.connect("inventory_modal_changed", self, "_on_inventory_modal_changed")
	animationTree.active = true
	rng.seed = OS.get_time().second
	set_soft_collision(false)
	stats.connect("item_equipped", self, "_on_item_equipped")
	reload()
	
func reload():
	bodySprite.texture = composite_sprites.body_spritesheet[stats.curr_body]
	hairSprite.texture = composite_sprites.hair_spritesheet[stats.curr_hair]["texture"]
	if composite_sprites.hair_spritesheet[stats.curr_hair].has("back_texture"):
		hairbackSprite.texture = composite_sprites.hair_spritesheet[stats.curr_hair]["back_texture"]
	else:
		hairbackSprite.texture = null
	bodySprite.get_material().set_shader_param("bodyMod", stats.bodyMod)	
	eyesSprite.get_material().set_shader_param("eyesMod", stats.eyesMod)	
	hairSprite.get_material().set_shader_param("age", stats.age)
	hairbackSprite.get_material().set_shader_param("age", stats.age)
	
func _on_item_equipped(item, item_type):
	stats.MAX_SPEED = stats.DEFAULT_MAX_SPEED
	mySprites.move_child(hatbackSprite, 0)
	mySprites.move_child(hairbackSprite, 1)
	mySprites.move_child(capebackSprite, 2)
#	mySprites.move_child(bodySprite, 3)
#	mySprites.move_child(bottomSprite, 4)
#	mySprites.move_child(topSprite, 5)
#	mySprites.move_child(shoesSprite, 6)
	mySprites.move_child(capeSprite, 7)
	mySprites.move_child(hairSprite, 8)
	mySprites.move_child(eyesSprite, 9)
	mySprites.move_child(hatSprite, 10)
	if item is Item:
		match item.type:
			"HAT":
				hatSprite.texture = item.texture
				hatbackSprite.texture = item.back_texture
				hairSprite.get_material().set_shader_param("mask_texture", item.mask_texture)
				hairbackSprite.get_material().set_shader_param("mask_texture", item.mask_texture)
				if !item.show_hair:
					hairSprite.texture = null
					hairbackSprite.texture = null
				else:
					hairSprite.texture = composite_sprites.hair_spritesheet[stats.curr_hair]["texture"]
					if composite_sprites.hair_spritesheet[stats.curr_hair].has("back_texture"):
						hairbackSprite.texture = composite_sprites.hair_spritesheet[stats.curr_hair]["back_texture"]
				stats.MAX_SPEED += stats.HatItem.speed_mod
			"TOP":
				topSprite.texture = item.texture
				if !item.show_bottom:
					bottomSprite.texture = null
				else:
					if stats.BottomItem is Item:
						bottomSprite.texture = stats.BottomItem.texture
					else:
						bottomSprite.texture = null
				if !item.show_shoes:
					shoesSprite.texture = null
				else:
					if stats.ShoesItem is Item:
						shoesSprite.texture = stats.ShoesItem.texture
					else:
						shoesSprite.texture = null
				if !item.show_cape:
					capeSprite.texture = null
					capebackSprite.texture = null
				else:
					if stats.CapeItem is Item:
						capeSprite.texture = stats.CapeItem.texture
						capebackSprite.texture = stats.CapeItem.back_texture
					else:
						capeSprite.texture = null
						capebackSprite.texture = null
				if stats.TopItem is Item:
					stats.MAX_SPEED += stats.TopItem.speed_mod
				if item.tuckable:
					if stats.curr_tuck:
						mySprites.move_child(bottomSprite, topSprite.get_index() + 1)
					else:
						mySprites.move_child(bottomSprite, topSprite.get_index())
						mySprites.move_child(topSprite, bottomSprite.get_index() + 1)
				else:
					mySprites.move_child(bottomSprite, topSprite.get_index())
					mySprites.move_child(topSprite, bottomSprite.get_index() + 1)
			"BOTTOM":
				bottomSprite.texture = item.texture
				if !item.show_shoes:
					shoesSprite.texture = null
				else:
					if stats.ShoesItem is Item:
						shoesSprite.texture = stats.ShoesItem.texture
					else:
						shoesSprite.texture = null
				stats.MAX_SPEED += stats.BottomItem.speed_mod
				if item.tuckable:
					mySprites.move_child(shoesSprite, bottomSprite.get_index() + 1)
				else:
					mySprites.move_child(shoesSprite, bottomSprite.get_index())
					mySprites.move_child(bottomSprite, shoesSprite.get_index() + 1)
			"SHOES":
				if stats.TopItem is Item:
					if !stats.TopItem.show_shoes:
						shoesSprite.texture = null
					else:
						shoesSprite.texture = stats.ShoesItem.texture
				else:
					shoesSprite.texture = item.texture
				stats.MAX_SPEED += stats.ShoesItem.speed_mod
			"CAPE":
				if stats.TopItem is Item:
					if !stats.TopItem.show_cape:
						capeSprite.texture = null
						capebackSprite.texture = null
					else:
						capeSprite.texture = stats.CapeItem.texture
						capebackSprite.texture = stats.CapeItem.back_texture
				else:
					capeSprite.texture = stats.CapeItem.texture
					capebackSprite.texture = stats.CapeItem.back_texture
				stats.MAX_SPEED += item.speed_mod
	else:
		match item_type:
			"HAT":
				hatSprite.texture = null
				hatbackSprite.texture = null
				hairSprite.texture = composite_sprites.hair_spritesheet[stats.curr_hair]["texture"]
				if composite_sprites.hair_spritesheet[stats.curr_hair].has('back_texture'):
					hairbackSprite.texture = composite_sprites.hair_spritesheet[stats.curr_hair]["back_texture"]
				hairSprite.get_material().set_shader_param("mask_texture", null)
				hairbackSprite.get_material().set_shader_param("mask_texture", null)
			"TOP":
				topSprite.texture = null
			"BOTTOM":
				bottomSprite.texture = null
			"SHOES":
				shoesSprite.texture = null
			"CAPE":
				capeSprite.texture = null
				capebackSprite.texture = null
	emit_signal("refresh_player_model", mySprites.duplicate())

func _draw():
	if show_vectors:
		match state:
			MOVE:
				draw_line(Vector2(0,0), velocity, Color(255, 0, 0), 2)

func _physics_process(delta):
	update()
	match state:
		MOVE:
			move_state(delta)
		SAD:
			pass
		TALKING:
			talking_state(delta)
		INVENTORY:
			pass
		MOUNTED:
			mounted_state(delta)
			
func inventory_state(_delta):
	cameraController.request_focus(self)
	
func mounted_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if just_mounted:
			just_mounted = false
		stats.mount.animationTree.set("parameters/Idle/blend_position", input_vector)
		stats.mount.animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/MountIdle/blend_position", input_vector)
		animationTree.set("parameters/MountRun/blend_position", input_vector)
		velocity = velocity.move_toward(input_vector * stats.mount.stats.MAX_SPEED, stats.mount.stats.ACCELERATION * delta)
		
		if round(velocity.length()) >= stats.mount.stats.RUN_SPEED:
			if !stats.hasDust:
				var dust_instance = DUST.instance()
				get_parent().add_child(dust_instance)
				dust_instance.global_position = global_position
				if input_vector.x < 0:
					dust_instance.get_node("AnimationPlayer").play("PoofRight")
				stats.hasDust = true
		animationState.travel("MountRun")
		stats.mount.animationState.travel("Run")
		if input_vector.x < 0:
			mySprites.position = stats.mount.get_node("LeftPlayerAttachPoint").position - Vector2($MountAttachPoint/LeftAttachPoint.position.x, $MountAttachPoint.position.y)
		elif input_vector.x > 0:
			mySprites.position = stats.mount.get_node("RightPlayerAttachPoint").position - Vector2($MountAttachPoint/RightAttachPoint.position.x, $MountAttachPoint.position.y)
		else:
			if input_vector.y > 0:
				mySprites.position = stats.mount.get_node("LeftPlayerAttachPoint").position - Vector2($MountAttachPoint/LeftAttachPoint.position.x, $MountAttachPoint.position.y)
			elif input_vector.y < 0:
				mySprites.position = stats.mount.get_node("RightPlayerAttachPoint").position - Vector2($MountAttachPoint/RightAttachPoint.position.x, $MountAttachPoint.position.y)
	else:
		if just_mounted:
			if stats.mount.get_node("Sprite").scale.x < 0:
				mySprites.position = stats.mount.get_node("LeftPlayerAttachPoint").position - Vector2($MountAttachPoint/LeftAttachPoint.position.x, $MountAttachPoint.position.y)
			elif stats.mount.get_node("Sprite").scale.x > 0:
				mySprites.position = stats.mount.get_node("RightPlayerAttachPoint").position - Vector2($MountAttachPoint/RightAttachPoint.position.x, $MountAttachPoint.position.y)
			else:
				if velocity.y > 0:
					mySprites.position = stats.mount.get_node("LeftPlayerAttachPoint").position - Vector2($MountAttachPoint/LeftAttachPoint.position.x, $MountAttachPoint.position.y)
				elif velocity.y < 0:
					mySprites.position = stats.mount.get_node("RightPlayerAttachPoint").position - Vector2($MountAttachPoint/RightAttachPoint.position.x, $MountAttachPoint.position.y)
		animationState.travel("MountIdle")
		stats.mount.animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, stats.mount.stats.FRICTION * delta)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 750
	velocity = move_and_slide(velocity)
	
		
	if velocity == Vector2.ZERO:
		stats.hasDust = false


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		
		velocity = velocity.move_toward(input_vector * stats.MAX_SPEED, stats.ACCELERATION * delta)
		
		if round(velocity.length()) < stats.RUN_SPEED:
			animationState.travel("Walk")
		else:
			if !stats.hasDust:
				var dust_instance = DUST.instance()
				get_parent().add_child(dust_instance)
				dust_instance.global_position = self.global_position
				if input_vector.x < 0:
					dust_instance.get_node("AnimationPlayer").play("PoofRight")
				stats.hasDust = true
			animationState.travel("Run")
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, stats.FRICTION * delta)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 750
	velocity = move_and_slide(velocity)
	
	if velocity == Vector2.ZERO:
		stats.hasDust = false
	
func set_soft_collision(option):
	softCollision.set_collision_layer_bit(5, option)
	softCollision.set_collision_mask_bit(5, option)
	
func face_left():
	animationTree.set("parameters/Idle/blend_position", Vector2(-1,0))	

func face_right():
	animationTree.set("parameters/Idle/blend_position", Vector2(1,0))
	
func talking_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Idle")
	stats.can_interact = false

func closest_interaction():
	var closest_distance = 1000000
	var distance_to = 0
	var closest
	for i in PlayerStats.interactPool:
		distance_to = i.global_position.distance_to(global_position)
		if distance_to < closest_distance:
			closest_distance = distance_to
			closest = i
	return closest
	
func add_to_pool(object):
	PlayerStats.interactPool.push_back(object)

func remove_from_pool(object):
	var place_in_line = PlayerStats.interactPool.find(object, 0)
	if place_in_line != -1:
		PlayerStats.interactPool.remove(place_in_line)
		
func clear_pool():
	PlayerStats.interactPool = []

func _on_inventory_modal_changed(modal_state):
	if modal_state:
		emit_signal("refresh_player_model", mySprites.duplicate())
		velocity = Vector2.ZERO
		stats.can_interact = false
		prev_state = state
		state = INVENTORY
	else:
		stats.can_interact = true
		state = prev_state

func mount(object):
	global_position = object.global_position
	object.get_parent().remove_child(object)
	$MountAttachPoint.add_child(object)
	
	# POSITION
#	mySprites.position = object.get_node("LeftPlayerAttachPoint").position - Vector2($MountAttachPoint/LeftAttachPoint.position.x, $MountAttachPoint.position.y)
	object.global_position = global_position
	stats.mount = object
	object.state = 2 # 2 is the MOVE state
	
	# COLLISION
	$CollisionShape2D.disabled = true
	mount_collision = object.get_node("CollisionShape2D").duplicate()
	add_child(mount_collision)
	mount_collision.global_position = object.get_node("CollisionShape2D").global_position
	object.set_collision_layer(2) # Must raise the layer to the power of 2 so Player layer is 2^1
	
	animationTree.active = false
	stats.mount.animationTree.active = false
	animationTree.active = true
	stats.mount.animationTree.active = true
	
	stats.can_interact = false
	if object.key_bubble_instance != null:
		object.key_bubble_instance.queue_free()
	prev_state = state
	state = MOUNTED
	$Shadow.visible = false
	object.stats.mounted = true
	just_mounted = true
	
func dismount(object):
	var scale_before = object.get_node("Sprite").scale
	$MountAttachPoint.remove_child(object)
	get_parent().add_child(object)
	# POSITION
	mySprites.position = Vector2.ZERO
	for sprite in mySprites.get_children():
		if sprite is Sprite:
			sprite.position = Vector2(0,-18)
	object.global_position = global_position
	stats.mount = null
	object.state = 0 # 0 is the IDLE state
	
	# COLLISION
	$CollisionShape2D.disabled = false
	remove_child(mount_collision)
	object.set_collision_layer(1) # Must raise the layer to the power of 2 so Player layer is 2^1
	stats.can_interact = true
	add_to_pool(object)
	state = MOVE
	$Shadow.visible = true
	object.stats.mounted = false
	object.get_node("Sprite").scale = scale_before
