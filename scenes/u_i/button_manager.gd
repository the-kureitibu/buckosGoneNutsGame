extends Control
#MarginContainer

@export var first_img: VBoxContainer
@export var sec_img: VBoxContainer
@export var sel_but_one: Button
@export var sel_but_two: Button
@export var sel_but_three: Button


func toggle_visiblity(object):
	if object.visible == true:
		object.visible = false
	else:
		object.visible = true

func _on_flip_button_pressed():
	toggle_visiblity(first_img)
	toggle_visiblity(sec_img)
	
func set_wave():
	$"..".visible = false
	Globals.weapon_selected = true
	Globals.defeated_mobs = Globals.W1_MAX_ENEMY_COUNT

func _on_button_one_pressed() -> void:
	Globals.wep_exchu = true 
	Globals.true_end = true
	print(Globals.true_end, 'true')
	set_wave()
	print("exchu") # exchu

func _on_button_two_pressed() -> void:
	Globals.wep_hanger = true
	Globals.bad_end = true
	print(Globals.bad_end, 'bad')
	set_wave()
	print("hanger")

func _on_button_three_pressed() -> void:
	Globals.wep_embrace = true
	Globals.good_end = true
	print(Globals.good_end, 'good')
	set_wave()
	print("embrace")
