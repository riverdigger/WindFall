extends Node

const body_spritesheet = {
	0 : preload("res://Player/Body/body.png"),
	1 : preload("res://Player/Body/body_old.png"),
}

const cape_spritesheet = {
	0 : {
		"name" : "None",
		"texture" : preload("res://Player/Capes/cape_none.png"),
	},
	1 : {
		"name" : "Dark Cloak",
		"texture" : preload("res://Player/Capes/cape_dark_cloak.png"),
		"back_texture" : preload("res://Player/Capes/cape_back_dark_cloak.png")
	},
	2 : {
		"name" : "Royal Cape",
		"texture" : preload("res://Player/Capes/cape_royal.png"),
		"back_texture" : preload("res://Player/Capes/cape_back_royal.png")
	},
}

const eyes_spritesheet = {
	0 : {
		"name" : "Default",
		"texture" : preload("res://Player/Eyes/eyes_default.png")
	},
	1 : {
		"name" : "Angry",
		"texture" : preload("res://Player/Eyes/eyes_angry.png")
	},
	2 : {
		"name" : "Sad",
		"texture" : preload("res://Player/Eyes/eyes_sad.png")
	},
}

const hat_spritesheet = {
	0 : {
		"name" : "None",
		"texture" : preload("res://Player/Hat/hat_none.png"),
		"show_hair" : true
	},
	1 : {
		"name" : "Helmet",
		"texture" : preload("res://Player/Hat/hat_helmet.png"),
		"show_hair" : false
	},
	2 : {
		"name" : "Captain's Helmet",
		"texture" : preload("res://Player/Hat/hat_helmet_captain.png"),
		"show_hair" : false
	},
	3 : {
		"name" : "Crown",
		"texture" : preload("res://Player/Hat/hat_crown.png"),
		"show_hair" : true,
		"back_texture" : preload("res://Player/Hat/hat_back_crown.png")
	},
	4 : {
		"name" : "Jester Hat",
		"texture" : preload("res://Player/Hat/hat_jester.png"),
		"show_hair" : false,
	},
	5 : {
		"name" : "Straw Hat",
		"texture" : preload("res://Player/Hat/hat_farmer.png"),
		"show_hair" : true,
		"back_texture" : preload("res://Player/Hat/hat_back_farmer.png"),
		"mask_texture": preload("res://Player/Hat/hat_farmer_mask.png"),
	},
	6 : {
		"name" : "Hood",
		"texture" : preload("res://Player/Hat/hat_hood.png"),
		"show_hair" : false
	},
}

const hair_spritesheet = {
	0 : {
		"name" : "Bald",
		"texture" : preload("res://Player/Hair/hair_none.png")
	},
	1 : {
		"name" : "Claire",
		"texture" : preload("res://Player/Hair/hair_claire.png"),
		"back_texture" : preload("res://Player/Hair/hair_back_claire.png")
	},
	2 : {
		"name" : "Niall",
		"texture" : preload("res://Player/Hair/hair_niall.png")
	},
	3 : {
		"name" : "Bowl",
		"texture" : preload("res://Player/Hair/hair_bowl.png")
	},
	4 : {
		"name" : "High Ponytail",
		"texture" : preload("res://Player/Hair/hair_ponytail_1.png")
	},
	5 : {
		"name" : "Wavy",
		"texture" : preload("res://Player/Hair/hair_wavy.png")
	},
	6 : {
		"name" : "Buzz",
		"texture" : preload("res://Player/Hair/hair_connie.png")
	},
	7 : {
		"name" : "Flowy",
		"texture" : preload("res://Player/Hair/hair_mermaid.png")
	},
	8 : {
		"name" : "Parted",
		"texture" : preload("res://Player/Hair/hair_dwight.png")
	},
	9 : {
		"name" : "Low Fade",
		"texture" : preload("res://Player/Hair/hair_low_fade.png")
	},
	10 : {
		"name" : "High Buns",
		"texture" : preload("res://Player/Hair/hair_high_bun.png")
	},
	11 : {
		"name" : "Short Ponytail",
		"texture" : preload("res://Player/Hair/hair_ponytail_2.png")
	},
	12 : {
		"name" : "Ochako",
		"texture" : preload("res://Player/Hair/hair_ochako.png")
	},
	13 : {
		"name" : "Curly",
		"texture" : preload("res://Player/Hair/hair_curly.png"),
		"back_texture" : preload("res://Player/Hair/hair_back_curly.png"),
	},
	14 : {
		"name" : "Swept",
		"texture" : preload("res://Player/Hair/hair_swept.png"),
	},
	15 : {
		"name" : "Gelled",
		"texture" : preload("res://Player/Hair/hair_gelled.png"),
	},
	16 : {
		"name" : "Fishtail",
		"texture" : preload("res://Player/Hair/hair_fishtail.png"),
	},
	17 : {
		"name" : "Santa",
		"texture" : preload("res://Player/Hair/hair_santa.png"),
	},
}

const bottom_spritesheet = {
	0 : {
		"name" : "Pantsless",
		"texture" : preload("res://Player/Bottom/bottom_none.png"),
		"tuckable" : true
	},
	1 : {
		"name" : "Slim Brown Pants",
		"texture" : preload("res://Player/Bottom/bottom_slim_brown.png"),
		"tuckable" : true
	},
	2 : {
		"name" : "Slim Blue Pants",
		"texture" : preload("res://Player/Bottom/bottom_slim_blue.png"),
		"tuckable" : true
	},
	3 : {
		"name" : "Slim Black Pants",
		"texture" : preload("res://Player/Bottom/bottom_slim_black.png"),
		"tuckable" : true
	},
	4 : {
		"name" : "Skirt",
		"texture" : preload("res://Player/Bottom/bottom_skirt.png"),
		"tuckable" : false
	},
	5 : {
		"name" : "Platelegs",
		"texture" : preload("res://Player/Bottom/bottom_plate.png"),
		"tuckable" : false
	},
}

const top_spritesheet = {
	0 : {
		"name" : "Shirtless",
		"texture" : preload("res://Player/Top/top_none.png"),
		"tuckable" : false,
		"show_pants" : true,
		"show_shoes" : true
	},
	1 : {
		"name" : "Dress Shirt",
		"texture" : preload("res://Player/Top/top_dress_shirt.png"),
		"tuckable" : true,
		"show_pants" : true,
		"show_shoes" : true		
	},
	2 : {
		"name" : "Ragged Shirt",
		"texture" : preload("res://Player/Top/top_sack.png"),
		"tuckable" : true,
		"show_pants" : true,
		"show_shoes" : true		
	},
	3 : {
		"name" : "Royal Ball Gown",
		"texture" : preload("res://Player/Top/top_ball_gown_purple.png"),
		"tuckable" : false,
		"show_pants" : false,
		"show_shoes" : false		
	},
	4 : {
		"name" : "Ruby Ball Gown",
		"texture" : preload("res://Player/Top/top_ball_gown_red.png"),
		"tuckable" : false,
		"show_pants" : false,
		"show_shoes" : false		
	},
	5 : {
		"name" : "Button Down",
		"texture" : preload("res://Player/Top/top_button_down.png"),
		"tuckable" : true,
		"show_pants" : true,
		"show_shoes" : true		
	},
	6 : {
		"name" : "Corset",
		"texture" : preload("res://Player/Top/top_corset.png"),
		"tuckable" : true,
		"show_pants" : true,
		"show_shoes" : true		
	},
	7 : {
		"name" : "Breastplate",
		"texture" : preload("res://Player/Top/top_breastplate.png"),
		"tuckable" : false,
		"show_pants" : true,
		"show_shoes" : true		
	},
	8 : {
		"name" : "Dark Shirt",
		"texture" : preload("res://Player/Top/top_shirt_dark.png"),
		"tuckable" : true,
		"show_pants" : true,
		"show_shoes" : true		
	},
}

const shoes_spritesheet = {
	0 : {
		"name" : "Barefoot",
		"texture" : preload("res://Player/Shoes/shoes_none.png"),
		"tuckable" : false
	},
	1 : {
		"name" : "Boots",
		"texture" : preload("res://Player/Shoes/shoes_boots.png"),
		"tuckable" : true
	},
	2 : {
		"name" : "Metal Boots",
		"texture" : preload("res://Player/Shoes/shoes_metal.png"),
		"tuckable" : true
	},
	3 : {
		"name" : "Black Boots",
		"texture" : preload("res://Player/Shoes/shoes_boots_black.png"),
		"tuckable" : true
	},
	4 : {
		"name" : "Vans",
		"texture" : preload("res://Player/Shoes/shoes_vans.png"),
		"tuckable" : true
	},
}
