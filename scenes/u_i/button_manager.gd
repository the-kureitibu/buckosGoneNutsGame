extends Control
#MarginContainer

@export var first_img: VBoxContainer
@export var sec_img: VBoxContainer
@export var sel_but_one: Button
@export var sel_but_two: Button
@export var sel_but_three: Button



#func _ready() -> void:
	#sel_button.pressed.connect(_on_flip_button_pressed.bind(sel_but))

func toggle_visiblity(object):
	if object.visible == true:
		object.visible = false
	else:
		object.visible = true

#func sel_but():
	#print('nice')

func _on_flip_button_pressed():
	toggle_visiblity(first_img)
	toggle_visiblity(sec_img)
	

#func _on_button_pressed() -> void:
	#
	#if sel_but_one:
		#print("one")

func _on_button_one_pressed() -> void:
	Globals.wep_exchu = true 
	$"..".visible = false
	Globals.weapon_selected = true
	print(Globals.wep_exchu)
	print("exchu") # exchu

func _on_button_two_pressed() -> void:
	Globals.wep_hanger = true
	$"..".visible = false
	Globals.weapon_selected = true
	print(Globals.wep_hanger) # hanger
	print("hanger")

func _on_button_three_pressed() -> void:
	Globals.wep_embrace = true
	$"..".visible = false
	Globals.weapon_selected = true
	print(Globals.wep_embrace) # embrace
	print("embrace")
