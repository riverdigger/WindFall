extends CenterContainer

var inventory = preload("res://Inventory.tres")
export(String, "ANY", "BOTTOM", "HAT", "SHOES", "TOP", "CAPE") var item_type
export(String, "INVENTORY", "EQUIPMENT") var container_type = "EQUIPMENT"
onready var itemTextureRect = $ItemTextureRect
onready var backgroundType = $BackgroundType

func display_item(item):
	if item is Item && item.name != "":
		backgroundType.visible = false		
		itemTextureRect.texture = item.icon
		PlayerStats.equip_item(item, item_type)
	else:
		backgroundType.visible = true
		itemTextureRect.texture = null
		PlayerStats.equip_item(null, item_type)

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_equipment_item(item_index)
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
	var my_item = inventory.equipment[my_item_index]
	
	if my_item is Item and my_item.name == data.item.name:
		inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item, data.container_type)
	else:
		if item_type == "ANY" || item_type == data.item.type:
			inventory.swap_items(my_item_index, container_type, item_type, data.item_index, data.container_type, data.item.type)
			inventory.set_item(my_item_index, data.item, container_type)
		else:
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item, data.container_type)
	inventory.drag_data = null
