extends CanvasLayer

var stats = PlayerStats
var composite_sprites = CompositeSprites
onready var player = Global.player
onready var npcs = get_node("../YSort/NPCs").get_children()
onready var inventoryContainer = $InventoryContainer
signal inventory_modal_changed(modal_state)

func _on_Randomize_pressed():
	ItemDB.randomize_object(player, true)
	for npc in npcs:
		npc.randomize_npc()

func _input(event):
	if Input.is_action_just_pressed("ui_inventory"):
		inventoryContainer.visible = !inventoryContainer.visible
		emit_signal("inventory_modal_changed", inventoryContainer.visible)
