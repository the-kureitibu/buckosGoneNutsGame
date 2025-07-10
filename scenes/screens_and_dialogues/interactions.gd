extends Node2D

class_name Interactions 
@onready var transition = $CanvasLayer2/Transition/ColorRect/AnimationPlayer
@onready var color_rect = $CanvasLayer2/Transition/ColorRect


#States
var is_pre_dia: bool = false
var is_start_dia: bool = false
var is_good_end: bool = false
var is_true_end: bool = false
var is_bad_end: bool = false
var is_dialogue_running: bool = false

#Character States
var is_ami_talk: bool = false
var is_elder1_talk: bool = false
var is_elder2_talk: bool = false
var is_elder3_talk: bool = false

#Dialogue Indexes 
var current_index := 0
var dialogue_a = []
#Labels
@export var dialogue_label: Label
@export var name_label: Label

#Signals 
signal dialogue_done

#Dialogues

 

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


func indexer(wave):
	
	if current_index < wave.size():
		dialogue_label.text = wave[current_index].line
		name_label.text = wave[current_index].speaker
		current_index += 1
	else:
		current_index = 0
		if wave == pre_dialogues: #This is the one
			dialogue_label.text = ""
			name_label.text = ""
			await play_transition_fi()
			await play_transition_fo()
			DialogueStates.current_dialogue_type = "pre_wave"
			
		elif wave == start_dialogues:
			await play_transition_fi()
			DialogueStates.current_dialogue_type = "wave_start"
			get_tree().change_scene_to_file("res://scenes/Scenes/level.tscn")
			queue_free()
		else:
			dialogue_done.emit()
			queue_free()

func pre_wave_dialogue(wave):
	#var index = current_index
	var str_captured = wave
	var dial: Array
	
	if str_captured == "start_dialogues":
		dial = start_dialogues
		if Input.is_action_just_pressed("primary(mouse)"):
			indexer(dial)

func wave_dialogue(wave_number, part):
	

	if wave_number == 1 and part == 1: 
		dialogue_a = pre_wave1_dialogues
	elif wave_number == 1 and part == 2: 
		dialogue_a = post_wave1_dialogues
	if wave_number == 2 and part == 1: 
		dialogue_a = pre_wave2_dialogues
	elif wave_number == 2 and part == 2: 
		dialogue_a = post_wave2_dialogues
	if wave_number == 3 and part == 1: 
		dialogue_a = pre_wave3_dialogues
	elif wave_number == 3 and part == 2: 
		dialogue_a = post_wave3_dialogues
		
	current_index = 0
	is_dialogue_running = true
	indexer(dialogue_a)
	await dialogue_done


func _unhandled_input(event: InputEvent) -> void:
	if is_dialogue_running and Input.is_action_just_pressed("primary(mouse)"):
		indexer(dialogue_a)

func starting_dialogue(wave):
	var str_captured = wave
	var dial: Array
	
	if str_captured == "pre_dialogues":
		dial = pre_dialogues
		if Input.is_action_just_pressed("primary(mouse)"):
			indexer(dial)
			
	if str_captured == "start_dialogues":
		dial = start_dialogues
		if Input.is_action_just_pressed("primary(mouse)"):
			indexer(dial)

func play_transition_fo():
	color_rect.color = Color(0, 0, 0, 1)
	color_rect.visible = true
	await get_tree().process_frame
	await get_tree().process_frame
	transition.play("fade_out")
	await transition.animation_finished
	color_rect.visible = false

func play_transition_fi():
	$CanvasLayer2.layer = 100
	color_rect.color = Color(0, 0, 0, 1)
	color_rect.visible = true
	await get_tree().process_frame
	transition.play("fade_in")
	await transition.animation_finished



func _ready() -> void:
	play_transition_fo()


func _process(_delta):
	if DialogueStates.current_dialogue_type == "pre_start":
		starting_dialogue("pre_dialogues")
	if DialogueStates.current_dialogue_type == "pre_wave":
		pre_wave_dialogue("start_dialogues")
