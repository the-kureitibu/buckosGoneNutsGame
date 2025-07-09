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

#Dialogue Indexes 
var current_index := 0

#Labels
@export var dialogue_label: Label
@export var name_label: Label

#Signals 
signal dialogue_done

#Dialogues

 # In case for later usage:
#var start_dialogues: Dictionary = {
	#"Ami" = [
		#"Bucko, Bucko, Bucko, Bucko, Bucko, Bucko, Buckoo- Are?!",
		#"Nani kore?",
		#"Neglected??!",
		#"...",
		#"You guys gone nuts?! Fine! Come get some!!"
	#],
	#"Elder1" = [
		#"...",
		#"..."
	#],
	#"Elder2" = [
		#"...",
		#"..."
	#],
	#"Elder3" = [
		#"You’ve come. SpidorMama.",
		#"We hast been neglected. As so it’s been decided we wage war.",
		#"...",
		#"Hah! Well quoth, Spidor. SOUND THE MARCH."
	#]
#}
#var pre_dialogues: Dictionary = {
	#"Narrating" = [
		#"On an island somewhere on the Ami planet…",
		#"Meanwhile…"
	#],
	#"Ami" = [],
	#"Elder1" = [ 
		#"Elder, the bros and gals are lacking chus; morale is low. What do we do?",
		#"... ",
		#"By thy shall."
	#],
	#"Elder2" = [
		#"..."
	#],
	#"Elder3" = [
		#"...",
		#"We go to war. Muster all legions"
	#]
#}
#var wave1_dialogues: Dictionary = {
	#"Ami" = [],
	#"Elder1" = [
		#"I’ll it it up to you, my brothers…"
	#],
	#"Elder2" = [
		#"Very well."
	#],
	#
	##On Boss Spawn
	#"Elder3" = [
		#"Well done.  Allow us see how long thou keep up." 
	#] 
#}
#var wave2_dialogues: Dictionary = {
	##On boss summon
	#"Ami" = [
		#"You tryna kill me or something?!?"
	#],
	#"Elder2" = [
		#"I’ve failed you, dearest brother."
	#],
	#
	##[0] On boss summon
	#"Elder3" = [
		#"Well done surviving until now, Spidor.",
		#"You’ve done well. I shall continue from hither on."
	#]
#}
##var wave3_dialogues: Dictionary = {
	##"Ami" = [],
	##"Elder1" = [],
	##"Elder2" = [],
	##"Elder3" = []
#}
#var true_end_dialogues: Dictionary = {
	#"Ami" = [
		#"You spoiled brats all you want are chus!! You silly buckos!"
	#],
	#"Elder3" = [
		#"It is not our fault 'tis gone from sight"
	#]
#}
#var good_end_dialogues: Dictionary = {
	#"Ami" = [
		#"Hmmp!"
	#],
	#"Elder1" = [
		#"This situation isn’t ill at all."
	#],
	#"Elder2" = [
		#"This situation isn’t ill at all."
	#],
	#"Elder3" = [
		#"This situation isn’t ill at all."
	#]
#}
#var bad_end_dialogues: Dictionary = {
	#"Ami" = [
		#"No buckos… NOOOOOOOO!!!!"
	#],
	#"Elder1" = [],
	#"Elder2" = [],
	#"Elder3" = [
		#"Thou've done it now, spidor mama. I might not but admit our methods are rough, 
		#yet  it is for the sake of getting pampered. This is the end. We bid thou farewell"
	#]
#}

var pre_dialogues: Array = [
	{"speaker": "Narrator", "line": "On an island somewhere on the Ami planet…", "emotion": ""},
	{"speaker": "Elder1", "line": "Elder, the bros and gals are lacking chus; morale is low. What do we do?", "emotion": ""},
	{"speaker": "Elder3", "line": "...", "emotion": ""},
	{"speaker": "Elder2", "line": "...", "emotion": ""},
	{"speaker": "Elder1", "line": "...", "emotion": ""},
	{"speaker": "Elder3", "line": "We go to war. Muster all legions", "emotion": ""},
	{"speaker": "Elder3", "line": "The Spidor's might is not to beest taken lighteth of. We wilt brace ourselves.", "emotion": ""},
	{"speaker": "Elder1", "line": "By thy shall.", "emotion": ""},
]

var start_dialogues: Array = [
	{"speaker": "Ami", "line": "Bucko, Bucko, Bucko, Bucko, Bucko, Bucko, Buckoo- Are?!", "emotion": ""},
	{"speaker": "Ami", "line": "Nani kore?", "emotion": ""},
	{"speaker": "Elder3", "line": "You’ve come. SpidorMama.", "emotion": ""},
	{"speaker": "Elder3", "line": "We hast been neglected. As so it’s been decided we wage war.", "emotion": ""},
	{"speaker": "Ami", "line": "Neglected??!", "emotion": ""},
	{"speaker": "Elder1", "line": "...", "emotion": ""},
	{"speaker": "Elder2", "line": "...", "emotion": ""},
	{"speaker": "Elder3", "line": "...", "emotion": ""},
	{"speaker": "Ami", "line": "...", "emotion": ""},
	{"speaker": "Elder1", "line": "...", "emotion": ""},
	{"speaker": "Elder2", "line": "...", "emotion": ""},
	{"speaker": "Ami", "line": "You guys gone nuts?! Fine! Come get some!!", "emotion": ""},
	{"speaker": "Elder3", "line": "Hah! Well quoth, Spidor. SOUND THE MARCH.", "emotion": ""}
]

#Pre wave dialogue
var pre_wave1_dialogues: Array = [
	{"speaker": "Elder3", "line": "Well done. Allow us see how long thou keep up.", "emotion": ""},
	{"speaker": "Ami", "line": "...", "emotion": ""}
]

var pre_wave2_dialogues: Array = [
	{"speaker": "Elder3", "line": "Well done surviving until now, Spidor.", "emotion": ""},
	{"speaker": "Ami", "line": "...", "emotion": ""},
	{"speaker": "Ami", "line": "You tryna kill me or something?!?", "emotion": ""}
]

var pre_wave3_dialogues: Array = []

#Post wave dialogue
var post_wave1_dialogues: Array = [
	{"speaker": "Elder1", "line": "I’ll it it up to you, my brothers…", "emotion": ""},
	{"speaker": "Elder2", "line": "Very well.", "emotion": ""}
]

var post_wave2_dialogues: Array = [
	{"speaker": "Elder2", "line": "I’ve failed you, dearest brother.", "emotion": ""},
	{"speaker": "Elder3", "line": "You’ve done well. I shall continue from hither on.", "emotion": ""}
]

var post_wave3_dialogues: Array = []

# Ending Dialogues
var true_end_dialogues: Array = [
	{"speaker": "Ami", "line": "You spoiled brats all you want are chus!! You silly buckos!", "emotion": ""},
	{"speaker": "Elder3", "line": "It is not our fault 'tis gone from sight", "emotion": ""},
]

var good_end_dialogues: Array = [
	{"speaker": "Ami", "line": "Hmmp!", "emotion": ""},
	{"speaker": "Elder3", "line": "It is not our fault 'tis gone from sight", "emotion": ""},
]

var bad_end_dialogues: Array = [
	{"speaker": "Elder3", "line": "Thou've done it now, spidor mama. I might not but admit our methods are rough,
		yet  it is for the sake of getting pampered. This is the end. We bid thou farewell", "emotion": ""},
	{"speaker": "Ami", "line": "No buckos… NOOOOOOOO!!!!", "emotion": ""}
]


func indexer(curent_index, wave):
	if current_index < wave.size():
		dialogue_label.text = wave[current_index].line
		print(dialogue_label.text, 'seq 1')
		current_index += 1
		print('seq : ', current_index )
	else:
		current_index = 0
		dialogue_done.emit()
		queue_free()

func wave_dialogue(wave_number, part):
	var index = current_index
	var dialogue_a: Array
	
	if wave_number == 1 and part == 1: 
		dialogue_a = pre_wave1_dialogues
		if Input.is_action_just_pressed("primary(mouse)"):
			indexer(index, dialogue_a)
	elif wave_number == 1 and part == 2: 
		dialogue_a = post_wave1_dialogues
		if Input.is_action_just_pressed("primary(mouse)"):
			indexer(index, dialogue_a)
	
	if wave_number == 2 and part == 1: 
		dialogue_a = pre_wave2_dialogues
		if Input.is_action_just_pressed("primary(mouse)"):
			indexer(index, dialogue_a)
	elif wave_number == 2 and part == 2: 
		dialogue_a = post_wave2_dialogues
		if Input.is_action_just_pressed("primary(mouse)"):
			indexer(index, dialogue_a)

	if wave_number == 3 and part == 1: 
		dialogue_a = pre_wave3_dialogues
		if Input.is_action_just_pressed("primary(mouse)"):
			indexer(index, dialogue_a)
	elif wave_number == 3 and part == 2: 
		dialogue_a = post_wave3_dialogues
		if Input.is_action_just_pressed("primary(mouse)"):
			indexer(index, dialogue_a)

func starting_dialogue(wave):
	var index = current_index
	
	if wave == pre_dialogues:
		if Input.is_action_just_pressed("primary(mouse)"):
			indexer(index, wave)
			
	if wave == start_dialogues:
		if Input.is_action_just_pressed("primary(mouse)"):
			indexer(index, wave)




func _ready() -> void:
	is_ami_talk = true
	
#input on click - next in the Array 

func _process(_delta):
	#starting_dialogue(pre_dialogues)
	wave_dialogue(2, 1)
