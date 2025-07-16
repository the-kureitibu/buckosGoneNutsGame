extends Node2D


#Preloaded Scenes 
@onready var player_stats = $Player/Player.stats

@onready var hanger: PackedScene = preload("res://projectile_scenes/hanger_projectile.tscn")
@onready var exchu: PackedScene = preload("res://projectile_scenes/exchu_projectile.tscn")
@onready var embrace: PackedScene = preload("res://projectile_scenes/embrace_projectile.tscn")


#func _on_VisibilityNotifier2D_screen_exited():
	#if distance_to($Player/Player) >= 1000:
		#set_physics_process(false)
#func _ready() -> void:
	#print(player_stats.weapon_listings[0])


func _on_player_launch_projectile(pos: Variant, dir: Variant) -> void:


	if WeaponsManager.weapon_selected == "exchu":
		var exchu_projectile = exchu.instantiate()
		exchu_projectile.position = pos
		exchu_projectile.rotation_degrees = rad_to_deg(dir.angle()) + 90
		exchu_projectile.direction = dir
		if PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGING:
			exchu_projectile.set_initial_stats(
				player_stats.weapon_listings[2],
				true
				)
		else:
			exchu_projectile.set_initial_stats(
				player_stats.weapon_listings[2],
				false
				)	
		$Projectiles.add_child(exchu_projectile)
	elif WeaponsManager.weapon_selected == "hanger":
		var hanger_projectile = hanger.instantiate()
		hanger_projectile.position = pos
		hanger_projectile.rotation_degrees = rad_to_deg(dir.angle()) + 90
		hanger_projectile.direction = dir
		
		if PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGING:
			hanger_projectile.set_initial_stats(
				player_stats.weapon_listings[0],
				true
				)
		else:
			hanger_projectile.set_initial_stats(
				player_stats.weapon_listings[0],
				false
				)
		$Projectiles.add_child(hanger_projectile)
	elif WeaponsManager.weapon_selected == "embrace":
		var embrace_projectile = embrace.instantiate()
		embrace_projectile.position = pos
		if PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGING:
			embrace_projectile.set_initial_stats(
				player_stats.weapon_listings[0],
				true
				)
		else:
			embrace_projectile.set_initial_stats(
				player_stats.weapon_listings[0],
				false
				)
		
		$Projectiles.add_child(embrace_projectile)
