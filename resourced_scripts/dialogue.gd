extends Node2D

#START
@onready var prologue: Array[Dictionary] = [
	{"speaker": "Narrator", "line": "In a parallel universe; On an island somewhere on the Ami planet…
", "emotion": ""},
	{"speaker": "Elder1", "line": "- Elder, the bros and gals are lacking Chus'; morale is low. What do we do?,", "emotion": ""},
	{"speaker": "Elder2", "line": "...", "emotion": ""},
	{"speaker": "Elder3", "line": "...", "emotion": ""},
	{"speaker": "Elder3", "line": "We go to war. Muster all legions", "emotion": ""},
	{"speaker": "Elder3", "line": "The Spidor's might is not to beest taken lighteth of. We might not but taketh caution", "emotion": ""},
	{"speaker": "Elder1/Elder2", "line": "By thy shall.", "emotion": ""}
]

var pre_game: Array[Dictionary] = [
	{"speaker": "", "line": "", "emotion": ""},
	{"speaker": "Narrator", "line": "Meanwhile...", "emotion": ""},
	{"speaker": "Ami", "line": "Bucko, Bucko, Bucko, Bucko, Bucko, Bucko, Buckoo- Are?! ", "emotion": ""},
	{"speaker": "Ami", "line": "Nani kore?", "emotion": ""},
	{"speaker": "Elder1/Elder2", "line": "...", "emotion": ""},
	{"speaker": "Elder3", "line": "You’ve come. Spidor Mama.", "emotion": ""},
	{"speaker": "Elder3", "line": "We hast been neglected. As so it’s been decided we wage war.", "emotion": ""},
	{"speaker": "Ami", "line": "Neglected??!", "emotion": ""},
	{"speaker": "Elder1", "line": "...", "emotion": ""},
	{"speaker": "Elder2", "line": "...", "emotion": ""},
	{"speaker": "Elder3", "line": "...", "emotion": ""},
	{"speaker": "Ami", "line": "...", "emotion": ""},
	{"speaker": "Ami", "line": "You guys gone nuts?! Fine! Come get some!!", "emotion": ""},
	{"speaker": "Elder3", "line": "Hah! Well quoth, Spidor. SOUND THE MARCH.", "emotion": ""}
]

#WAVES

var pre_wave_one: Array[Dictionary] = [
	{"speaker": "Elder3", "line": "Well done. Allow us see how long thou keep up", "emotion": ""}
]

var post_wave_one: Array[Dictionary] = [
	{"speaker": "Elder1", "line": "I’ll it it up to you, my brothers…", "emotion": ""},
	{"speaker": "Elder2", "line": "Very well.", "emotion": ""}
]

var pre_wave_two: Array[Dictionary] = [
	{"speaker": "Elder2", "line": "Well done surviving until now, Spidor.", "emotion": ""},
	{"speaker": "Ami", "line": "You tryna kill me or something?!?", "emotion": ""}
]

var post_wave_two: Array[Dictionary] = [
	{"speaker": "Elder2", "line": "I’ve failed you, dearest brother.", "emotion": ""},
	{"speaker": "Elder3", "line": "You’ve done well. I shall continue from hither on.", "emotion": ""}
]

var pre_wave_three: Array[Dictionary] = [
	{"speaker": "Elder3", "line": "t is timeth, Spidor.", "emotion": ""},
	{"speaker": "Ami", "line": "Show me what you got bucko.", "emotion": ""}
]


#ENDINGS 

var true_end: Array[Dictionary] = [
	{"speaker": "Ami", "line": "You spoiled brats all you want are chus!! You silly buckos! ", "emotion": ""},
	{"speaker": "Elder3", "line": "It is not our fault  'tis gone from sight.", "emotion": ""}
]

var bad_end: Array[Dictionary] = [
	{"speaker": "Elder3", "line": "Thou've done it now, spidor mama.  I might not but admit our methods are rough,  yet  it is for the sake of getting pampered.  This is the end.  We bid thou farewell", "emotion": ""},
	{"speaker": "Ami", "line": "No buckos… NOOOOOOOO!!!!", "emotion": ""}
]

var good_end: Array[Dictionary] = [
	{"speaker": "Ami", "line": "Hmmp!", "emotion": ""},
	{"speaker": "Elder1/Elder2/Elder3", "line": "This situation isn’t ill at all.", "emotion": ""}
]
