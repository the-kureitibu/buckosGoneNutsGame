extends Node2D


#Preloaded Scenes 
@onready var player_stats = $Player/Player.stats
@onready var hanger: PackedScene = preload("res://projectile_scenes/hanger_projectile.tscn")
@onready var exchu: PackedScene = preload("res://projectile_scenes/exchu_projectile.tscn")
@onready var embrace: PackedScene = preload("res://projectile_scenes/embrace_projectile.tscn")
@onready var text_man: PackedScene = preload("res://ui_scenes/text_manager.tscn")
@onready var dialogue_scene: PackedScene = preload("res://ui_scenes/dialogue_manager.tscn")
@onready var test_ui: PackedScene = preload("res://ui_scenes/weapon_selection_ui.tscn")
@onready var start_menu = preload("res://ui_scenes/starting_menu.tscn")
@onready var skill_one = preload("res://projectile_scenes/skill_one.tscn")
@onready var skill_two = preload("res://projectile_scenes/skill_two.tscn")
@onready var skill_three = preload("res://projectile_scenes/skill_three.tscn")
@onready var bgm = $AudioStreamPlayer2D
@onready var bgm_is_playing := false
@onready var test_bgm = $AudioStreamPlayer
@onready var boss_bgm = $AudioStreamPlayer2

#Waves Tscns
@onready var buckos: PackedScene = preload("res://scenes/enemy.tscn")

#Spawners
const MIN_PLAYER_DIST := 200
const MAX_PLAYER_DIST := 750
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
var gate := 0

#Skill stuff
var is_launching := false


func launch_skill_one():
	if PlayerManager.player_died == true:
		return
	
	if is_launching:
		return 
	
	is_launching = true
	var skill_markers = $Player/Player.get_node("SkillMarkers").get_children()
	for marker in skill_markers:
		_spawn_one_at_a_time(marker)
		await get_tree().create_timer(0.5).timeout
		
	is_launching = false
	
func _spawn_one_at_a_time(marker: Marker2D):
	var instance = skill_one.instantiate()
	instance.position = marker.global_position
	instance.direction = Vector2.RIGHT.rotated(marker.rotation)
	instance.rotation_degrees = rad_to_deg(marker.rotation) + 90
	instance.target_node = marker
	$SkillProjectiles.add_child(instance)
	
	if instance.has_method("start"):
		instance.start(marker)

func _on_player_skill_launched(skill_num: Variant, pos: Variant, dir: Variant) -> void:
	match skill_num:
		1:
			launch_skill_one()
		2:
			var skill2 = skill_two.instantiate()
			skill2.position =  pos + Vector2(0, -10.0)
			skill2.rotation_degrees = rad_to_deg(dir.angle()) + 90
			$SkillProjectiles.add_child(skill2)
		3:
			var skill3 = skill_three.instantiate()
			skill3.position = pos
			skill3.rotation_degrees = rad_to_deg(dir.angle()) + 90
			skill3.direction = dir
			$SkillProjectiles.add_child(skill3)



func _on_VisibilityNotifier2D_screen_exited():
	if global_position.distance_to($Player/Player.global_position) >= 1000:
		set_physics_process(false)
#
func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)

func _ready() -> void:
	#print(GameManager.game_started)
	await TransitionsManager.fade_out()
	bgm_is_playing = true
	play_bgm()
	var wp_ui = test_ui.instantiate()
	add_child(wp_ui)
	$DirectionalLight2D.rotation = deg_to_rad(-90)


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
				player_stats.weapon_listings[1],
				true
				)
		else:
			embrace_projectile.set_initial_stats(
				player_stats.weapon_listings[1],
				false
				)
		
		$Projectiles.add_child(embrace_projectile)

func boss_music():
	test_bgm.stop()
	boss_bgm.play()


func play_bgm():

	if bgm_is_playing:
		if !test_bgm.playing:
			test_bgm.volume_db = -60.0
			test_bgm.play()
			fade_music(-10.0, 2.0)
		
	else:
		if test_bgm.playing:
			test_bgm.stop()

func fade_music(target_db: float, duration: float):
	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(test_bgm, "volume_db", target_db, duration)
	
	
func _process(_delta: float) -> void:
	
	if GameManager.weapon_select and !GameManager.game_started and !is_wave_done:
		GameManager.game_started = true
		bgm_is_playing = true
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
	if spawn_count >= GameManager.current_wave_mobs:
		return
	
	var target = $Player/Player
	var valid_position = get_valid_points()

	if valid_position.is_empty():
		print("NO VALID MARKERS. (Player @", $Player/Player.global_position, ")")
		return
	var spawn_location = valid_position[randi() % valid_position.size()]
	var enemy = buckos.instantiate()
	enemy.position = $Enemies.to_local(spawn_location.global_position)
	$Enemies.add_child(enemy)
	#enemy.position = spawn_location.global_position
	
	if target:
		enemy.nav_target = target
	
	if enemy.is_connected("death", reduce_active_enemies):
		enemy.disconnect("death", reduce_active_enemies)
	
	enemy.connect("death", reduce_active_enemies)
	active_enemies += 1
	spawn_count += 1
	

func run_wave_dialogue(wave: int, part: int):
	

	get_tree().paused = true
	fade_music(-28.0, 0.25)
	
	var dialogue = dialogue_scene.instantiate()

	add_child(dialogue)
	
	dialogue.set_current_dialogue(wave, part)

	await dialogue.finished
	get_tree().paused = false
	fade_music(-10.0, 0.25) 


func spawn_boss(index: int):
	EnemyStateManager.boss_state = EnemyStateManager.EnemyStates.BOSS_SPAWNED
	boss_music()
	
	var target = $Player/Player
	var valid_position = get_valid_points()
	
	if valid_position.is_empty():
		print("NO VALID MARKERS. (Player @", $Player/Player.global_position, ")")
		return
	var spawn_location = valid_position[randi() % valid_position.size()]
	var boss = GameManager._waves.waves[index].instantiate()
	boss.position = $Enemies.to_local(spawn_location.global_position)
	$Enemies.add_child(boss)
	#enemy.position = spawn_location.global_position
	
	if target:
		boss.nav_target = target
	
	boss.connect("death", reduce_active_enemies)
	boss.connect("death", boss_death_bgm)
	active_enemies += 1
	spawn_count += 1


func boss_death_bgm():
	fade_music(-28.0, 0.25)
	boss_bgm.stop()
	test_bgm.play()
	fade_music(-10.0, 0.25) 
	
func reduce_active_enemies():

	active_enemies = max(active_enemies - 1, 0)
	GameManager.current_wave_quota = max(GameManager.current_wave_quota - 1, 0)
	enemy_deaths = min(enemy_deaths + 1, GameManager.current_wave_mobs)
	print("[DEBUG] Enemy died. enemy_deaths:", enemy_deaths, "active_enemies:", active_enemies, "spawn_count:", spawn_count)
	
	#print(enemy_deaths, ' deaths')
	
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
		
func _on_spawn_timer_timeout() -> void:
	if GameManager.current_wave == 1 and enemy_deaths >= GameManager.current_wave_mobs and active_enemies == 0:
		is_wave_done = true
		run_wave_dialogue(1,2)
		on_wave_cleared()
		return
	
	if spawn_count >= GameManager.current_wave_mobs:
		#$SpawnTimer.stop()
		#print('is timer stopped? ', $SpawnTimer.is_stopped())
		return

	if active_enemies >= max_enemies:
		##if gate >= GameManager.current_wave_mobs:
			##$SpawnTimer.stop()
			##print('is timer stopped? on active enemies ', $SpawnTimer.is_stopped())
		#else:
		return
	
	spawn_mobs()

func on_wave_cleared():
	EnemyStateManager.boss_state = EnemyStateManager.EnemyStates.IDLE
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
	if GameManager.current_wave == 2 and enemy_deaths >= GameManager.current_wave_mobs and active_enemies == 0:
		is_wave_done = true
		run_wave_dialogue(2,2)
		on_wave_cleared()
		return
	
	if active_enemies >= max_enemies:
		return
	
	if spawn_count >= GameManager.current_wave_mobs:
		return
	
	spawn_mobs()


func _on_wave_3_spawn_timer_timeout() -> void:
	if GameManager.current_wave == 3 and enemy_deaths >= GameManager.current_wave_mobs and active_enemies == 0:
		is_wave_done = true
		$Wave3SpawnTimer.stop()
		await TransitionsManager.fade_in()
		get_tree().change_scene_to_file("res://ui_scenes/ending_dialogue.tscn")
		queue_free()
		
		return
	
	if active_enemies >= max_enemies:
		return
	
	if spawn_count >= GameManager.current_wave_mobs:
		return
	
	spawn_mobs()


func _on_player_player_death() -> void:
	if PlayerManager.player_died:
		return
		
	PlayerManager.player_died = true
	GameManager.restart_game = true
	var text = text_man.instantiate()
	add_child(text)
	await text.death_announce()
	
	
	
	await TransitionsManager.fade_in()
	var new_sc = start_menu.instantiate()
	var tree = get_tree()
	var cur_scene = tree.get_current_scene()
	tree.get_root().add_child(new_sc)
	tree.get_root().remove_child(cur_scene)
	tree.set_current_scene(new_sc)
	return 
