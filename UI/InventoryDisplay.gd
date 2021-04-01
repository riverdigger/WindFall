extends GridContainer

var inventory = preload("res://Inventory.tres")
var item_scene = preload("res://Items/Item.tscn")
const POOF = preload("res://Effects/Poof.tscn")

func _ready():
	inventory.connect("items_changed", self, "_on_items_changed")
	inventory.make_items_unique()
	update_inventory_display()
	
func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)
	
func update_inventory_slot_display(item_index):
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	inventorySlotDisplay.display_item(item)
	
func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)
		
func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			# TODO FIGURE OUT HOW TO EQUIP/UNEQUIP ITEMS ALONGSIDE ITEM DROPS
#			print(inventory.drag_data)
			if inventory.drag_data.container_type == "INVENTORY":
				inventory.remove_item(inventory.drag_data.item_index)
				var new_item = item_scene.instance()
				new_item.item = inventory.drag_data.item
				get_node("../../../../YSort").add_child(new_item)
				new_item.global_position = get_node("../../../../YSort/Player").global_position + Vector2(((randi() % 4) + 1), ((randi() % 4) + 1))
			elif inventory.drag_data.container_type == "EQUIPMENT":
				inventory.remove_equipment_item(inventory.drag_data.item_index)
				var new_item = item_scene.instance()
				new_item.item = inventory.drag_data.item
				get_node("../../../../YSort").add_child(new_item)
				new_item.global_position = get_node("../../../../YSort/Player").global_position + Vector2(((randi() % 4) + 1), ((randi() % 4) + 1))
			var poof_instance = POOF.instance()
			poof_instance.position = get_global_mouse_position()
			get_node("../../../../GUIController").add_child(poof_instance)
			inventory.drag_data = null
