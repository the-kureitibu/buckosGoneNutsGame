extends Node2D


#Preloaded Scenes 
@onready var player_stats = $Player/Player.stats
@onready var hanger: PackedScene = preload("res://projectile_scenes/hanger_projectile.tscn")
@onready var exchu: PackedScene = preload("res://projectile_scenes/exchu_projectile.tscn")
@onready var embrace: PackedScene = preload("res://projectile_scenes/embrace_projectile.tscn")
@onready var text_man: PackedScene = preload("res://ui_scenes/text_manager.tscn")
@onready var dialogue_scene: PackedScene = preload("res://ui_scenes/dialogue_manager.tscn")
@onready var test_ui: PackedScene = preload("res://ui_scenes/weapon_selection_ui.tscn")

#Spawners
const MIN_PLAYER_DIST := 200
const MAX_PLAYER_DIST := 600
@onready var max_enemies = GameManager.max_active_enemies
var enemy_deaths := 0
var active_enemies := 0
var spawn_count := 0
@onready var markers = $SpawnMarkers.get_children()
var boss_one_spawned := false
var boss_two_spawned := false
var boss_three_spawned := false
var is_wave_two_started: bool = false
var is_wave_three_started: bool = false
var is_wave_done := false



func _ready() -> void:
	await TransitionsManager.fade_out()
	var wp_ui = test_ui.instantiate()
	add_child(wp_ui)

##For refactor
#func start_wave(wave: int):
	#var enemy_deaths := 0
	#var active_enemies := 0
	#var spawn_count := 0
	#
	#

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
	
	if GameManager.weapon_select and !GameManager.game_started and !is_wave_done:
		GameManager.game_started = true
		game_start()
	

func game_start():
	if GameManager.game_started and GameManager.current_wave == 1 and !is_wave_done:
		$SpawnTimer.stop()
	
		var text = text_man.instantiate()
		add_child(text)
		await text.wave_announcer(1)
		
		await get_tree().create_timer(1.0).timeout
		
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

func run_wave_dialogue(wave: int, part: int):
	

	get_tree().paused = true
	
	var dialogue = dialogue_scene.instantiate()

	add_child(dialogue)
	
	dialogue.set_current_dialogue(wave, part)

	await dialogue.finished
	get_tree().paused = false


func spawn_boss(index: int):
	print('boss spawned? ')
	var target = $Player/Player
	var valid_position = get_valid_points()
	
	if valid_position.is_empty():
		print("NO VALID MARKERS. (Player @", $Player/Player.global_position, ")")
		return
	var spawn_location = valid_position[randi() % valid_position.size()]
	var boss = GameManager._waves.waves[index].instantiate()
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
	
	if !boss_one_spawned and GameManager.current_wave == 1 and enemy_deaths >= GameManager.current_wave_mobs / 2:
		boss_one_spawned = true
		run_wave_dialogue(1,1)
		call_deferred("spawn_boss", 1)
	elif !boss_two_spawned and GameManager.current_wave == 2 and enemy_deaths >= GameManager.current_wave_mobs / 2:
		boss_two_spawned = true
		run_wave_dialogue(2,1)
		call_deferred("spawn_boss", 2)
	elif !boss_three_spawned and GameManager.current_wave == 3 and enemy_deaths >= GameManager.current_wave_mobs / 2:
		boss_three_spawned = true
		run_wave_dialogue(3,1)
		call_deferred("spawn_boss", 3)
		
	print('current active enemies: ', active_enemies, ' current enemy death: ', enemy_deaths, ' current wave mobs: ', GameManager.current_wave_mobs)

func _on_spawn_timer_timeout() -> void:
	if GameManager.current_wave == 1 and enemy_deaths >= GameManager.current_wave_mobs:
		is_wave_done = true
		run_wave_dialogue(1,2)
		on_wave_cleared()
		return
	
	if active_enemies >= max_enemies / 4:
		return
	
	if spawn_count >= GameManager.current_wave_mobs:
		return
	
	spawn_mobs()

func on_wave_cleared():
	
	if GameManager.current_wave == 1:
		$SpawnTimer.stop()
	elif GameManager.current_wave == 2:
		$Wave2SpawnTimer.stop()

	active_enemies = 0
	spawn_count = 0
	enemy_deaths = 0
	next_wave_setter()

func next_wave_setter():
	if GameManager.current_wave == 1:
		GameManager.wave_setter(2)
		start_wave_after_delay(2)
	elif GameManager.current_wave == 2:
		GameManager.wave_setter(3)
		start_wave_after_delay(3)

func start_wave_after_delay(wave: int):
	await get_tree().create_timer(2.0).timeout
	if wave == 2:
		$Wave2SpawnTimer.stop()
	
		var text = text_man.instantiate()
		add_child(text)
		await text.wave_announcer(2)
		
		await get_tree().create_timer(1.0).timeout
		
		is_wave_done = false
		$Wave2SpawnTimer.start()
		

	elif wave == 3:
		$Wave3SpawnTimer.stop()
	
		var text = text_man.instantiate()
		add_child(text)
		await text.wave_announcer(3)
		
		await get_tree().create_timer(1.0).timeout
		
		is_wave_done = false
		$Wave3SpawnTimer.start()
		
#func wave_two_start():
	#$Wave2SpawnTimer.start()
	#is_wave_done = false
	#print('wave 2 started ')
	#print(GameManager.current_wave)
	#print('active enemies, : ', active_enemies, 'spawn count: ', spawn_count, ' enemy deaths: ', enemy_deaths)
#
#func wave_three_start():
	#$Wave3SpawnTimer.start()
	#is_wave_done = false
	#print('wave 3 started ')
	#print(GameManager.current_wave)
	#print('active enemies, : ', active_enemies, 'spawn count: ', spawn_count, ' enemy deaths: ', enemy_deaths)


func _on_wave_2_spawn_timer_timeout() -> void:
	if GameManager.current_wave == 2 and enemy_deaths >= GameManager.current_wave_mobs:
		is_wave_done = true
		run_wave_dialogue(2,2)
		on_wave_cleared()
		return
	
	if active_enemies >= max_enemies / 4:
		return
	
	if spawn_count >= GameManager.current_wave_mobs:
		return
	
	spawn_mobs()


func _on_wave_3_spawn_timer_timeout() -> void:
	if GameManager.current_wave == 3 and enemy_deaths >= GameManager.current_wave_mobs:
		is_wave_done = true
		$Wave3SpawnTimer.stop()
		await TransitionsManager.fade_in()
		get_tree().change_scene_to_file("res://ui_scenes/ending_dialogue.tscn")
		queue_free()
		
		
		#run ending 
		return
	
	if active_enemies >= max_enemies / 4:
		return
	
	if spawn_count >= GameManager.current_wave_mobs:
		return
	
	spawn_mobs()
