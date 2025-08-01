extends CanvasLayer


var main_character: PlayerStats = preload("res://resources/player_stats_manager.tres")
var new_resource = PlayerStats

#HTP Info
var how_to: Array = [
	{"title": "Moving Ami", 
	"description": "Move Ami with W/A/S/D. Movement and shooting direction determined by mouse cursor",},
	{"title": "Shooting Buckos", "description": "Use mouse's left click to shoot buckos.",},
	{"title": "Rage", 
	"description": "Every successful hit the spidor acculumates rage until she's angy. 
	She loves the buckos though so she won't be angy for long. ",},
	{"title": "Essence of the true spidor", 
	"description": "If the spidor is not hit in the last 10 seconds she restore a little bit of HP",},
	{"title": "How To Win", "description": "Finish the game by clearing all 3 Waves and defeating all buckos",},
	{"title": "How To Pause", "description": "Press ESC to show the menu",},
	{"title": "Caution!", "description": "Watch out for bugs!",},
	{"title": "Using Skills", "description": "Use mouse's right click to throw some bucko plushies!",},
]
var current_index := 0
@export var how_to_title: Label
@export var how_to_descrip: Label

#Button switchers 
@export var wep1_info: Label
@export var wep1_image: NinePatchRect
@export var wep2_info: Label
@export var wep2_image: NinePatchRect
@export var wep3_info: Label
@export var wep3_image: NinePatchRect



func visibility_toggle(object):
	if object.visible == true: 
		object.visible = false
	else:
		object.visible = true


func _ready() -> void:
	new_resource = main_character.duplicate()
	how_to_title.text = how_to[0].title
	how_to_descrip.text = how_to[0].description
	$HowToPlay.visible = true
	$ExchuMarginContainer.visible = false
	$EmbraceMarginContainer2.visible = false
	$HangerMarginContainer3.visible = false
	$MarginContainer.visible = false
	
	$AnimationPlayer.play("how_to_one")
	
# Switcher buttons 
# Exchulibladder 

func _on_wep_1_info_button_1_pressed() -> void:
	visibility_toggle(wep1_info)
	visibility_toggle(wep1_image)


func _on_wep_1_info_button_2_pressed() -> void:
	visibility_toggle(wep1_info)
	visibility_toggle(wep1_image)

#Embrace
func _on_wep_2_info_button_1_pressed() -> void:
	visibility_toggle(wep2_info)
	visibility_toggle(wep2_image)


func _on_wep_2_info_button_2_pressed() -> void:
	visibility_toggle(wep2_info)
	visibility_toggle(wep2_image)


#Hanger
func _on_wep_3_info_button_1_pressed() -> void:
	visibility_toggle(wep3_info)
	visibility_toggle(wep3_image)


func _on_wep_3_info_button_2_pressed() -> void:
	visibility_toggle(wep3_info)
	visibility_toggle(wep3_image)

#Main Buttons 

#func _ready() -> void:
	#print(main_character.selected_weapon)
#

func _on_weapon_1_select_button_pressed() -> void:
	main_character.selected_weapon = WeaponsManager.weapon_list["exchu"]
	GameManager.true_end = true
	GameManager.current_wave = 1
	GameManager.weapon_select = true
	WeaponsManager.weapon_selected = "exchu"
	#GameManager.game_started = true
	$"../Player/Player".setup_stats()
	#get_parent().get_node("Player").setup_stats()
	queue_free()
	
func _on_weapon_2_select_button_pressed() -> void:
	main_character.selected_weapon = WeaponsManager.weapon_list["embrace"]
	GameManager.good_end = true
	GameManager.current_wave = 1
	GameManager.weapon_select = true
	WeaponsManager.weapon_selected = "embrace"
	#GameManager.game_started = true
	#get_parent().get_par("Player").setup_stats()
	$"../Player/Player".setup_stats()
	queue_free()
	


func _on_weapon_3_select_button_pressed() -> void:
	main_character.selected_weapon = WeaponsManager.weapon_list["hanger"]
	GameManager.bad_end = true
	GameManager.current_wave = 1
	GameManager.weapon_select = true
	WeaponsManager.weapon_selected = "hanger"
	#GameManager.game_started = true
	$"../Player/Player".setup_stats()
	queue_free()



func _on_button_left_pressed() -> void:
	
	#current_index = clamp(current_index, -6, 6)
	
	if current_index <= 0 :
		current_index = how_to.size()
		#print(current_index, 'here')
	
	current_index -= 1
	
	how_to_title.text = how_to[current_index].title
	how_to_descrip.text = how_to[current_index].description

func _on_button_right_pressed() -> void:

	if current_index >= 7:
		current_index = 0
		how_to_title.text = how_to[0].title
		how_to_descrip.text = how_to[0].description
	else:
		current_index += 1
		
	how_to_title.text = how_to[current_index].title
	how_to_descrip.text = how_to[current_index].description
	


func _on_button_close_pressed() -> void:
	$AnimationPlayer.play("how_to_two")
	await $AnimationPlayer.animation_finished
	
	$AnimationPlayer.play("wep_select_one")
	$ExchuMarginContainer.visible = true
	$EmbraceMarginContainer2.visible = true
	$HangerMarginContainer3.visible = true
	$MarginContainer.visible = true
	
