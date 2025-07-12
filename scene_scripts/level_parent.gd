extends Node2D

class_name LevelParent

#Preloaded Scenes 
@onready var hanger_attack: PackedScene = preload("res://projectile_scenes/hanger_projectile.tscn")
@onready var exchu_attack: PackedScene = preload("res://projectile_scenes/exchu_projectile.tscn")
@onready var embrace_attack: PackedScene = preload("res://projectile_scenes/embrace_projectile.tscn")


func projectile_handler(weapon, pos, dir):
	
	var weap = weapon.instantiate()
	weap.position = pos
	weap.rotation_degrees = rad_to_deg(dir.angle()) + 90
	weap.direction = dir
	weap.range_handler(pos)
	$Projectiles.add_child(weap)

func _on_player_launch_projectile(pos: Variant, dir: Variant) -> void:
	
	
	var hanger_projectile = embrace_attack.instantiate()
	hanger_projectile.position = pos
	#hanger_projectile.rotation_degrees = rad_to_deg(dir.angle()) + 90
	#hanger_projectile.direction = dir
	#
	$Projectiles.add_child(hanger_projectile)

	#if WeaponsManager.exchulibladder: 
		#projectile_handler(exchu_attack, pos, dir)
	#elif WeaponsManager.hanger: 
		#projectile_handler(exchu_attack, pos, dir)
	#elif WeaponsManager.embrace: 
		#var exchu_weapon = exchu_attack.instantiate()
		#hanger_projectile.position = pos
		#hanger_projectile.rotation_degrees = rad_to_deg(dir.angle()) + 90
		
		#$Projectiles.add_child(exchu_weapon)
