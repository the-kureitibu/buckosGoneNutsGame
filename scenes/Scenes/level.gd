extends Node2D

var get_hanger_proj: PackedScene = preload("res://projectiles/projectile_hanger.tscn")
var get_exchu_proj: PackedScene = preload("res://projectiles/exchu_li_bladder.tscn")
var get_embrace_proj: PackedScene = preload("res://projectiles/ami_embrace.tscn")

func get_weapon(weapon):
	var get_wep = weapon.instantiate() as Area2D
	return get_wep

func _on_ami_projectle(pos, direction):
	# var get_hangproj = get_exchu_proj.instantiate() as Area2D 
	if Globals.wep_exchu == true:
		var weapon = get_weapon(get_exchu_proj)
		weapon.position = pos
		weapon.rotation_degrees = rad_to_deg(direction.angle()) + 90
		weapon.direction = direction
		$Projectiles.add_child(weapon)
	elif Globals.wep_hanger == true:
		var weapon = get_weapon(get_hanger_proj)
		weapon.position = pos
		weapon.rotation_degrees = rad_to_deg(direction.angle()) + 90
		weapon.direction = direction
		$Projectiles.add_child(weapon)
	elif Globals.wep_embrace == true:
		var weapon = get_embrace_proj.instantiate() as Area2D
		weapon.position = pos
		$Projectiles.add_child(weapon)


#func _on_ui_weapon_selected() -> void:
	#Globals.game_ready = true
