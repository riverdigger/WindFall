extends Resource
class_name Item

export(String) var name = ""
export(Texture) var icon
export(Texture) var texture
export(Texture) var back_texture
export(Texture) var mask_texture
export(bool) var show_hair
export(bool) var show_bottom
export(bool) var show_shoes
export(bool) var show_cape
export(bool) var tuckable
export(float) var speed_mod = 0
export(float) var type_roll_weight = 1.0
var type_acc_weight = 0.0
export(float) var tot_roll_weight = 1.0
var tot_acc_weight = 0.0

export(String, "BOTTOM", "HAT", "SHOES", "TOP", "CAPE") var type

var amount = 1
