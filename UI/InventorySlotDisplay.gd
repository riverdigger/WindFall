extends CenterContainer

var inventory = preload("res://Inventory.tres")
export(String, "ANY", "BOTTOM", "HAT", "SHOES", "TOP", "CAPE") var item_type = "ANY"
export(String, "INVENTORY", "EQUIPMENT") var container_type = "INVENTORY"
onready var itemTextureRect = $ItemTextureRect
onready var itemAmountLabel = $ItemTextureRect/ItemAmountLabel
#onready var typeSprite = $ItemTextureRect/TypeSprite

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.icon
#		if item.type == "HAT":
#			typeSprite.texture = load("res://UI/HatType.png")
#		elif item.type == "CAPE":
#			typeSprite.texture = load("res://UI/CapeType.png")
#		elif item.type == "TOP":
#			typeSprite.texture = load("res://UI/TopType.png")
#		elif item.type == "BOTTOM":
#			typeSprite.texture = load("res://UI/BottomType.png")
#		elif item.type == "SHOES":
#			typeSprite.texture = load("res://UI/ShoesType.png")
#		else:
#			typeSprite.texture = null
			
		if item.amount != 1:
			itemAmountLabel.text = str(item.amount)
		else:
			itemAmountLabel.text = ""
	else:
		itemTextureRect.texture = null
#		typeSprite.texture = null
		itemAmountLabel.text = ""

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		data.container_type = container_type
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.icon
		set_drag_preview(dragPreview)
		inventory.drag_data = data
		return data
	
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	
	if my_item is Item and my_item.name == data.item.name:
		my_item.amount += data.item.amount
		inventory.emit_signal("items_changed", [my_item_index])
	else:
		if item_type == "ANY" || item_type == data.item.type:
			inventory.swap_items(my_item_index, container_type, item_type, data.item_index, data.container_type, data.item.type)
			inventory.set_item(my_item_index, data.item, container_type)
		else:
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item, data.container_type)
	inventory.drag_data = null
