extends CanvasLayer


@export var main_character: PlayerStats
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

func _ready() -> void:
	print(main_character.selected_weapon)


func _on_weapon_1_select_button_pressed() -> void:
	main_character.selected_weapon = WeaponsManager.weapon_list["exchu"]
	GameManager.true_end = true
	WeaponsManager.weapon_selected = "exchu"
	queue_free()
	

func _on_weapon_2_select_button_pressed() -> void:
	main_character.selected_weapon = WeaponsManager.weapon_list["embrace"]
	GameManager.good_end = true
	WeaponsManager.weapon_selected = "embrace"
	queue_free()
	


func _on_weapon_3_select_button_pressed() -> void:
	main_character.selected_weapon = WeaponsManager.weapon_list["hanger"]
	GameManager.bad_end = true
	WeaponsManager.weapon_selected = "hanger"
	queue_free()
