extends Node

# http://kehomsforge.com/tutorials/single/GDWeightedRandom/ Weighted Randomness
onready var player = Global.player
export(Array, Resource) var bottoms = []
export(Array, Resource) var tops = []
export(Array, Resource) var hats = []
export(Array, Resource) var shoes = []
export(Array, Resource) var capes = []
var inventory = preload("res://Inventory.tres")
var composite_sprites = CompositeSprites
var rng = RandomNumberGenerator.new()
var total_weight
var bottoms_weight
var tops_weight
var hats_weight
var shoes_weight
var capes_weight
var total_items = []

func lookup_item(name):
	for item in total_items:
		if item.name == name:
			return item

	return null

func init_probabilities():
	# Reset total_weight to make sure it holds the correct value after initialization
	total_weight = 0.0
	bottoms_weight = 0.0
	tops_weight = 0.0	
	hats_weight = 0.0
	shoes_weight = 0.0
	capes_weight = 0.0
	total_items = bottoms + tops + hats + shoes + capes
	for item in total_items:
		total_weight += item.tot_roll_weight
		item.tot_acc_weight = total_weight
		if item.type == "BOTTOM":
			bottoms_weight += item.type_roll_weight
			item.type_acc_weight = bottoms_weight
		elif item.type == "TOP":
			tops_weight += item.type_roll_weight
			item.type_acc_weight = tops_weight
		elif item.type == "HAT":
			hats_weight += item.type_roll_weight
			item.type_acc_weight = hats_weight
		elif item.type == "SHOES":
			shoes_weight += item.type_roll_weight
			item.type_acc_weight = shoes_weight
		elif item.type == "CAPE":
			capes_weight += item.type_roll_weight
			item.type_acc_weight = capes_weight
#	for i in range(0,100):
#		print(rng.randf_range(0,5))
#	for item in shoes:
#		print(item.name, ": ", item.type_roll_weight, "|", item.type_acc_weight)
	
func pick_random_item(type="ANY"):
	if total_weight == null || bottoms_weight == null || tops_weight == null || hats_weight == null || shoes_weight == null || capes_weight == null:
		init_probabilities()
	if type == "ANY":
		var roll = rng.randf_range(0.0, total_weight)
		for item in total_items:
			if (item.tot_acc_weight > roll):
				return item
	elif type == "TOP":
		var roll = rng.randf_range(0.0, tops_weight)
		for item in tops:
			if (item.type_acc_weight > roll):
				return item
	elif type == "BOTTOM":
		var roll = rng.randf_range(0.0, bottoms_weight)
		for item in bottoms:
			if (item.type_acc_weight > roll):
				return item
	elif type == "HAT":
		var roll = rng.randf_range(0.0, hats_weight)
		for item in hats:
			if (item.type_acc_weight > roll):
#				print("Picked: ", item.name, " | Roll (", roll, ") -> ", item.type_acc_weight)
				return item
	elif type == "SHOES":
		var roll = rng.randf_range(0.0, shoes_weight)
		for item in shoes:
			if (item.type_acc_weight > roll):
				return item
	elif type == "CAPE":
		var roll = rng.randf_range(0.0, capes_weight)
		for item in capes:
			if (item.type_acc_weight > roll):
				return item
	
	return Item.new()

func generate_random_equipment(object, is_player):
#	rng.seed *= object.get_instance_id()
	var bottom_item = pick_random_item("BOTTOM")
	var top_item = pick_random_item("TOP")
	var hat_item = pick_random_item("HAT")
	var shoes_item = pick_random_item("SHOES")
	var cape_item = pick_random_item("CAPE")
#	var bottom_item = bottoms[rng.randi_range(0, bottoms.size() - 1)]
#	var top_item = tops[rng.randi_range(0, tops.size() - 1)]
#	var hat_item = hats[rng.randi_range(0, hats.size() - 1)]
#	var shoes_item = shoes[rng.randi_range(0, shoes.size() - 1)]
#	var cape_item = capes[rng.randi_range(0, capes.size() - 1)]
	if is_player:
		inventory.equipment = [hat_item, cape_item, top_item, bottom_item, shoes_item]
		inventory.refresh_equipment()
	object.stats.equip_item(bottom_item, "BOTTOM")
	object.stats.equip_item(top_item, "TOP")
	object.stats.equip_item(hat_item, "HAT")
	object.stats.equip_item(shoes_item, "SHOES")
	object.stats.equip_item(cape_item, "CAPE")
	
func randomize_object(object, is_player):
	rng.randomize()

	object.stats.age = rng.randf_range(18.0, 90.0)
	object.stats.curr_eyes = rng.randi_range(0, composite_sprites.eyes_spritesheet.size() - 1)
	object.stats.curr_hair = rng.randi_range(0, composite_sprites.hair_spritesheet.size() - 1)
	
	
	object.stats.bodyMod = rng.randf_range(-0.5, 0.22) # good skin color range
	object.stats.eyesMod = rng.randf()
	if object.stats.age >= 70.0:	
		object.stats.curr_body = 1
	else:
		object.stats.curr_body = 0
	
	object.bodySprite.texture = composite_sprites.body_spritesheet[object.stats.curr_body]
	object.hairSprite.texture = composite_sprites.hair_spritesheet[object.stats.curr_hair]["texture"]
	if composite_sprites.hair_spritesheet[object.stats.curr_hair].has("back_texture"):
		object.hairbackSprite.texture = composite_sprites.hair_spritesheet[object.stats.curr_hair]["back_texture"]
	else:
		object.hairbackSprite.texture = null
	object.bodySprite.get_material().set_shader_param("bodyMod", object.stats.bodyMod)	
	object.eyesSprite.get_material().set_shader_param("eyesMod", object.stats.eyesMod)	
	object.hairSprite.get_material().set_shader_param("age", object.stats.age)
	object.hairbackSprite.get_material().set_shader_param("age", object.stats.age)

	generate_random_equipment(object, is_player)
