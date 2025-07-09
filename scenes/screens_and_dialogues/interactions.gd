extends Node2D

#States
var is_pre_dia: bool = false
var is_start_dia: bool = false 
var is_good_end: bool = false
var is_true_end: bool = false
var is_bad_end: bool = false

#Character States
var is_ami_talk: bool = false
var is_elder1_talk: bool = false
var is_elder2_talk: bool = false 
var is_elder3_talk: bool = false

#Dialogues

var pre_dialogues: Dictionary = {
	"Narrating" = [
		"On an island somewhere on the Ami planet…",
		"Meanwhile…"
	],
	"Ami" = [],
	"Elder1" = [ 
		"Elder, the bros and gals are lacking chus; morale is low. What do we do?",
		"... ",
		"By thy shall."
	],
	"Elder2" = [
		"..."
	],
	"Elder3" = [
		"...",
		"We go to war. Muster all legions"
	]
}

var start_dialogues: Dictionary = {
	"Ami" = [
		"Bucko, Bucko, Bucko, Bucko, Bucko, Bucko, Buckoo- Are?!",
		"Nani kore?",
		"Neglected??!",
		"...",
		"You guys gone nuts?! Fine! Come get some!!"
	],
	"Elder1" = [
		"...",
		"..."
	],
	"Elder2" = [
		"...",
		"..."
	],
	"Elder3" = [
		"You’ve come. SpidorMama.",
		"We hast been neglected. As so it’s been decided we wage war.",
		"...",
		"Hah! Well quoth, Spidor. SOUND THE MARCH."
	]
}

var wave1_dialogues: Dictionary = {
	"Ami" = [],
	"Elder1" = [
		"I’ll it it up to you, my brothers…"
	],
	"Elder2" = [
		"Very well."
	],
	
	#On Boss Spawn
	"Elder3" = [
		"Well done.  Allow us see how long thou keep up." 
	] 
}

var wave2_dialogues: Dictionary = {
	#On boss summon
	"Ami" = [
		"You tryna kill me or something?!?"
	],
	"Elder2" = [
		"I’ve failed you, dearest brother."
	],
	
	#[0] On boss summon
	"Elder3" = [
		"Well done surviving until now, Spidor.",
		"You’ve done well. I shall continue from hither on."
	]
}

var wave3_dialogues: Dictionary = {
	"Ami" = [],
	"Elder1" = [],
	"Elder2" = [],
	"Elder3" = []
}

var true_end_dialogues: Dictionary = {
	"Ami" = [
		"You spoiled brats all you want are chus!! You silly buckos!"
	],
	"Elder3" = [
		"It is not our fault 'tis gone from sight"
	]
}

var good_end_dialogues: Dictionary = {
	"Ami" = [
		"Hmmp!"
	],
	"Elder1" = [
		"This situation isn’t ill at all."
	],
	"Elder2" = [
		"This situation isn’t ill at all."
	],
	"Elder3" = [
		"This situation isn’t ill at all."
	]
}

var bad_end_dialogues: Dictionary = {
	"Ami" = [
		"No buckos… NOOOOOOOO!!!!"
	],
	"Elder1" = [],
	"Elder2" = [],
	"Elder3" = [
		"Thou've done it now, spidor mama. I might not but admit our methods are rough, 
		yet  it is for the sake of getting pampered. This is the end. We bid thou farewell"
	]
}

func dialog_line(wave: int):
	#Access Dictionary per wave 
		#wave = dictionary 
	#Access the Dictionary key based on sequence 
		#wave = dictionary.key (start character)
	#Input clicks will follow the sequence and grab the keys and Array indexes based on sequence
		#wave = dictionary.key (start character)
		#Boolean = talking? 
		#wave = dictionary.key[+1]
		#Call Array index +1 per clicks 
	#Display in label 
	#Change texture/sprite base on who is talking
	var dict: Dictionary
	if wave == 1:
		pass
	if wave == 2:
		pass
	if wave == 3:
		pass

	
func _ready() -> void:
	pass
#input on click - next in the Array 
