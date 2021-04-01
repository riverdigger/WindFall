extends GridContainer

var inventory = preload("res://Inventory.tres")

func _ready():
	inventory.connect("equipment_items_changed", self, "_on_equipment_items_changed")
	inventory.make_items_unique()
	update_inventory_display()
	
func update_inventory_display():
	for item_index in inventory.equipment.size():
		update_inventory_slot_display(item_index)
	
func update_inventory_slot_display(item_index):
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.equipment[item_index]
	inventorySlotDisplay.display_item(item)
	
func _on_equipment_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)
		
#func _unhandled_input(event):
#	if event.is_action_released("ui_left_mouse"):
#		if inventory.drag_data is Dictionary:
#			# TODO FIGURE OUT HOW TO EQUIP/UNEQUIP ITEMS ALONGSIDE ITEM DROPS
##			print(inventory.drag_data)
##			if inventory.drag_data.container_type == "INVENTORY":
##				print("INVENTORY")
##				inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item, "INVENTORY")
##			elif inventory.drag_data.container_type == "EQUIPMENT":
##				print("EQUIPMENT")
##				inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item, "EQUIPMENT")
##			else:
#				#dropped item
#			inventory.remove_item(inventory.drag_data.item_index)
#			var new_item = item_scene.instance()
#			new_item.item = inventory.drag_data.item
#			get_node("../../../YSort").add_child(new_item)
#			new_item.global_position = get_node("../../../YSort/Player").global_position + Vector2(((randi() % 4) + 1), ((randi() % 4) + 1))
