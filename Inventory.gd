extends Resource
class_name Inventory

var drag_data = null

signal items_changed(indexes)
signal equipment_items_changed(indexes)

export(Array, Resource) var items = [
	null, null, null, null, null, null, null, null, null, null,
	null, null, null, null, null, null, null, null, null, null,
	null, null, null, null, null, null, null, null, null, null,
	null, null, null, null, null, null, null, null, null, null,
	null, null, null, null, null, null, null, null, null, null,
	null, null, null, null, null, null, null, null, null, null,
]

export(Array, Resource) var equipment = [
	null, null, null, null,
]

func refresh_equipment():
	for item_index in range(0, equipment.size()):
		emit_signal("equipment_items_changed", [item_index])

func set_item(item_index, item, target_container):
	var existingItem
	if target_container == "INVENTORY":
		existingItem = items[item_index]
		items[item_index] = item
		emit_signal("items_changed", [item_index])
	elif target_container == "EQUIPMENT":
		existingItem = equipment[item_index]
		equipment[item_index] = item
		emit_signal("equipment_items_changed", [item_index])
	return existingItem

func swap_items(item_index, from_container, item_type, target_item_index, target_container, target_type):
#	print("Item i: ", item_index, " | From Container: ", from_container, " | Target i: ", target_item_index, " | Target Container: ", target_container)
	if from_container == "INVENTORY" && target_container == "INVENTORY":
		var targetItem = items[target_item_index]
		var item = items[item_index]
		items[target_item_index] = item
		items[item_index] = targetItem
		emit_signal("items_changed", [item_index, target_item_index])
	elif from_container == "INVENTORY" && target_container == "EQUIPMENT":
		var targetItem = equipment[target_item_index]
		var item = items[item_index]
		if item_type == target_type:
			equipment[target_item_index] = item
			items[item_index] = targetItem
			emit_signal("items_changed", [item_index])
			emit_signal("equipment_items_changed", [target_item_index])
	elif from_container == "EQUIPMENT" && target_container == "INVENTORY":
		var targetItem = items[target_item_index]
		var item = equipment[item_index]
		if item_type == target_type:
			items[target_item_index] = item
			equipment[item_index] = targetItem
			emit_signal("items_changed", [target_item_index])
			emit_signal("equipment_items_changed", [item_index])
	elif from_container == "EQUIPMENT" && target_container == "EQUIPMENT":
		var targetItem = equipment[target_item_index]
		var item = equipment[item_index]
		if item_type == target_type:
			equipment[target_item_index] = item
			equipment[item_index] = targetItem
			emit_signal("equipment_items_changed", [item_index, target_item_index])
	
func remove_item(item_index):
	var existingItem = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return existingItem

func remove_equipment_item(item_index):
	var existingItem = equipment[item_index]
	equipment[item_index] = null
	emit_signal("equipment_items_changed", [item_index])
	return existingItem
	
func make_items_unique():
	var unique_items = []
	for item in items:
		if item is Item:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	items = unique_items
	
	unique_items = []
	for item in equipment:
		if item is Item:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	equipment = unique_items
