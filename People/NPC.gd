extends KinematicBody2D

onready var stats = $Stats
var composite_sprites = CompositeSprites
onready var playerDetectionZone = $PlayerDetectionZone
export var show_vectors = false
var circle_pos = Vector2.ZERO
var radian = 0

# STATES
enum {
	IDLE,
	WANDER,
	NAVIGATE,
	APPROACH,
	TALKING
}

var state = WANDER setget set_state
var prev_state = WANDER
var ignore_collisions = false
var rng = RandomNumberGenerator.new()
var velocity = Vector2.ZERO
onready var softCollision = $SoftCollision
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
onready var cameraController = get_node("../../../CameraController")
onready var animationPlayer = $CompositeSprites/AnimationPlayer
onready var animationTree = $CompositeSprites/AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var navigation = $Navigation
const DUST = preload("res://Effects/Dust.tscn")
onready var player = get_node("../../Player")
var key_bubble_instance
var bush_instance

func _ready():
	animationTree.active = true
	stats.connect("item_equipped", self, "_on_item_equipped")
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		randomize_npc()

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
	

func _draw():
	if show_vectors:
		match state:
			WANDER:
				draw_circle(circle_pos - global_position, stats.WANDER_RING_RADIUS, Color(0, 255, 0))
				draw_line(Vector2(0,0), (circle_pos - global_position) + Vector2(stats.WANDER_RING_RADIUS, 0).rotated(radian), Color(255, 0, 0), 2)
				draw_line(circle_pos - global_position, (circle_pos - global_position) + Vector2(stats.WANDER_RING_RADIUS, 0).rotated(radian), Color(0, 0, 255), 2)
			APPROACH:
				draw_line(Vector2(0,0), velocity, Color(255, 0, 0), 2)				
		if softCollision.is_colliding():
			draw_line(Vector2.ZERO, softCollision.get_push_vector()*10, Color(200, 100, 0), 2)

func _physics_process(delta):
	update()
	var direction = stats.target
	if stats.path.size() > 0:
		state = NAVIGATE
	match state:
		IDLE:
			direction = Vector2.ZERO
			if softCollision.is_colliding():
				direction += softCollision.get_push_vector().normalized() + Vector2(0.1,0)
				animationState.travel("Walk")
			else:
				if velocity == Vector2.ZERO:
					animationState.travel("Idle")
			if stats.path.size() > 0:
				state = NAVIGATE
			detect_player()
		WANDER:
			wander_state(delta)
		APPROACH:
			var player_area = playerDetectionZone.player
			# need to update to only zoom on player if 
			if player_area != null:
				if key_bubble_instance != null:
					key_bubble_instance.hide()
				direction = player_area.global_position - global_position
				if round(direction.length()) == 30:
					cameraController.request_focus(self)
					state = TALKING
				elif round(direction.length()) < 30:
					player.set_soft_collision(true)
					if global_position.x < player_area.global_position.x:
						direction = (player_area.global_position + Vector2(-30, 0) - global_position)
					else:
						direction = (player_area.global_position + Vector2(30, 0) - global_position)
			else:
				state = prev_state
		NAVIGATE:
			if softCollision.is_colliding():
				direction += softCollision.get_push_vector()
			navigate_state(delta)
		TALKING:
			direction = Vector2.ZERO
			talking_state(delta)
	seek(direction, delta)

func detect_player():
	if playerDetectionZone.can_see_player() && PlayerStats.can_interact && self == player.closest_interaction():
		if key_bubble_instance == null:
			var KeyBubble = load("res://UI/KeyBubble.tscn")
			key_bubble_instance = KeyBubble.instance()
			add_child(key_bubble_instance)
			key_bubble_instance.global_position = $InteractKeyAttachPoint.global_position
		if Input.is_action_just_pressed("interact"):
			state = APPROACH
	else:
		if key_bubble_instance != null:
			key_bubble_instance.hide()

func navigate_state(delta):
	detect_player()
	navigation.move_along_path(delta)

func wander_state(_delta):
	detect_player()

func seek(input_vector, delta):
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
		velocity += softCollision.get_push_vector().normalized()
	
	velocity = move_and_slide(velocity)
	navigation.check_for_collisions()
	
	
	if velocity == Vector2.ZERO:
		stats.hasDust = false
	

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func talking_state(_delta):
	player.set_soft_collision(false)
	animationState.travel("Idle")
	
	var player_area = playerDetectionZone.player
	if player_area != null:
		if global_position.x > player_area.global_position.x:
			animationTree.set("parameters/Idle/blend_position", Vector2(-1,0))
			player.face_right()
		else:
			animationTree.set("parameters/Idle/blend_position", Vector2(1,0))
			player.face_left()
			
	if stats.can_interact && Input.is_action_just_pressed("interact"):
		if key_bubble_instance != null:
			key_bubble_instance.show()
		cameraController.abandon_focus(self)
		state = prev_state

func _on_PlayerDetectionZone_interact_started():
	player.add_to_pool(self)

func _on_PlayerDetectionZone_interact_ended():
	player.remove_from_pool(self)
	if key_bubble_instance != null:
		key_bubble_instance.queue_free()
	cameraController.abandon_focus(self)
	state = prev_state

func _on_Timer_timeout():
	# Smooth Turn Wander
	if state == WANDER:
		circle_pos = global_position + velocity.normalized() * stats.WANDER_RING_DISTANCE
		radian = rng.randi_range(0,360) * PI / 180
		stats.target = (circle_pos - global_position) + Vector2(stats.WANDER_RING_RADIUS, 0).rotated(radian)

func randomize_npc():
	rng.randomize()
	stats.MAX_SPEED = rng.randi_range(40, 60)
	stats.DEFAULT_MAX_SPEED = stats.MAX_SPEED
	ItemDB.randomize_object(self, false)
	
func set_state(value):
	prev_state = state
	state = value	

func save():
	var equipment = []
	if stats.HatItem:
		equipment.push_back(stats.HatItem.name)
	if stats.CapeItem:
		equipment.push_back(stats.CapeItem.name)
	if stats.TopItem:
		equipment.push_back(stats.TopItem.name)
	if stats.BottomItem:
		equipment.push_back(stats.BottomItem.name)
	if stats.ShoesItem:
		equipment.push_back(stats.ShoesItem.name)
#	print(equipment)
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"curr_body": stats.curr_body,
		"curr_eyes": stats.curr_eyes,
		"curr_hair": stats.curr_hair,
		"equipment": equipment,
		"age": stats.age,
		"bodyMod": stats.bodyMod,
		"eyesMod": stats.eyesMod,
		"MAX_SPEED": stats.MAX_SPEED,
		"mount": stats.mount,
		"path": stats.path,
		"velocity_x": velocity.x,
		"velocity_y": velocity.y,
		"target_x": stats.target.x,
		"target_y": stats.target.y
	}
	return save_dict
	
func load_from_data(data):
	velocity = Vector2(data["velocity_x"], data["velocity_y"])
	stats.target = Vector2(data["target_x"], data["target_y"])
	stats.MAX_SPEED = data["MAX_SPEED"]
	stats.DEFAULT_MAX_SPEED = stats.MAX_SPEED

	stats.age = data["age"]
	stats.curr_eyes = int(data["curr_eyes"])
	stats.curr_hair = int(data["curr_hair"])
	
	stats.bodyMod = data["bodyMod"]
	stats.eyesMod = data["eyesMod"]
	if stats.age >= 70.0:
		stats.curr_body = 1
	else:
		stats.curr_body = 0
	
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

	for item_name in data["equipment"]:
		var item = ItemDB.lookup_item(item_name)
		if item:
			stats.equip_item(item, item.type)
