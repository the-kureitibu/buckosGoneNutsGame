extends Node2D


#Preloaded Scenes 
@onready var player_stats = $Player/Player.stats
@onready var hanger: PackedScene = preload("res://projectile_scenes/hanger_projectile.tscn")
@onready var exchu: PackedScene = preload("res://projectile_scenes/exchu_projectile.tscn")
@onready var embrace: PackedScene = preload("res://projectile_scenes/embrace_projectile.tscn")


#Spawners
const MIN_PLAYER_DIST := 200
const MAX_PLAYER_DIST := 600
@onready var max_enemies = GameManager.max_active_enemies
var enemy_deaths := 0
var active_enemies := 0
var spawn_count := 0
@onready var markers = $SpawnMarkers.get_children()
var boss_spawned := false

#
func _ready() -> void:
	print(max_enemies)

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

func _process(delta: float) -> void:
	
	if GameManager.weapon_select and !GameManager.game_started: 
		GameManager.game_started = true
		game_start()
		print('is Timer stop?: ', !$SpawnTimer.is_stopped())


func game_start():
	if GameManager.game_started and GameManager.current_wave == 1:
		$SpawnTimer.start()

func get_valid_points():
	
	var valid_points = []
	for i in markers:
		var distance = i.global_position.distance_to($Player/Player.global_position)
		if distance > MIN_PLAYER_DIST and distance < MAX_PLAYER_DIST:
			valid_points.append(i)
	return valid_points

func spawn_mobs():
	var target = $Player/Player
	var valid_position = get_valid_points()

	if valid_position.is_empty():
		print("NO VALID MARKERS. (Player @", $Player/Player.global_position, ")")
		return
	var spawn_location = valid_position[randi() % valid_position.size()]
	var enemy = GameManager._waves.waves[0].instantiate()
	enemy.position = $Enemies.to_local(spawn_location.global_position)
	$Enemies.add_child(enemy)
	print("Spawned at:", enemy.global_position, " marker:", spawn_location.global_position)
	#enemy.position = spawn_location.global_position
	
	if target: 
		enemy.nav_target = target
	
	enemy.connect("death", reduce_active_enemies)
	active_enemies += 1
	spawn_count += 1
	print('spawning now? ', active_enemies)


func spawn_boss():
	print('boss spawned? ')
	var target = $Player/Player
	var valid_position = get_valid_points()
	
	if valid_position.is_empty():
		print("NO VALID MARKERS. (Player @", $Player/Player.global_position, ")")
		return
	var spawn_location = valid_position[randi() % valid_position.size()]
	var boss = GameManager._waves.waves[3].instantiate()
	boss.position = $Enemies.to_local(spawn_location.global_position)
	$Enemies.add_child(boss)
	print("Spawned boss at:", boss.global_position, " marker:", spawn_location.global_position)
	#enemy.position = spawn_location.global_position
	
	if target: 
		boss.nav_target = target
	
	boss.connect("death", reduce_active_enemies)
	active_enemies += 1
	spawn_count += 1
	
func reduce_active_enemies():
	active_enemies -= 1
	GameManager.current_wave_quota -= 1
	enemy_deaths += 1
	
	if !boss_spawned and enemy_deaths >= GameManager.current_wave_mobs / 2:
		boss_spawned = true
		call_deferred("spawn_boss")
		
	print('current active enemies: ', active_enemies, ' current enemy death: ', enemy_deaths, ' current wave mobs: ', GameManager.current_wave_mobs)

func _on_spawn_timer_timeout() -> void:
	if enemy_deaths >= GameManager.current_wave_mobs:
		on_wave_cleared()
	
	if active_enemies >= max_enemies / 4:
		return
	
	if spawn_count >= GameManager.current_wave_mobs:
		return
	
	spawn_mobs()

func on_wave_cleared():
	print('is Timer stop?: ', !$SpawnTimer.is_stopped())
	$SpawnTimer.stop()
	next_wave_setter()

func next_wave_setter():
	GameManager.wave_setter(2)
