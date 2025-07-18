extends Node2D

#Misc
@onready var transition = $CanvasLayer/Transition/ColorRect/AnimationPlayer
@onready var color_rect = $CanvasLayer/Transition/ColorRect
@onready var dialogues = preload("res://scenes/screens_and_dialogues/interactions.tscn")
@onready var game_messages = $GameMessages


# Weapon Projectiles Scenes
var get_hanger_proj: PackedScene = preload("res://projectiles/projectile_hanger.tscn")
var get_exchu_proj: PackedScene = preload("res://projectiles/exchu_li_bladder.tscn")
var get_embrace_proj: PackedScene = preload("res://projectiles/ami_embrace.tscn")
@onready var dmg_popup = preload("res://scenes/u_i/damage_popup.tscn")

# Wave States
var ROUND_COUNT = 5
var resume_spawn_treshold = 20
var active_enemies = 0
var enemies_spawn = 0
var enemy_deaths = 0
var MAX_SPAWN_SIZE: int = 30
var current_wave = 0
var has_spawn_ended: bool = false
var has_spawn_started: bool = false

#Boss stuff
var boss_is_summoned: bool = false
var boss2_is_summoned: bool = false
var boss3_is_summoned: bool = false
var boss_one_is_dead: bool = false
var boss_two_is_dead: bool = false
var boss_three_is_dead: bool = false


#Wave Spawn Stuff
const MAX_DISTANCE = 600
const MIN_DISTANCE = 200
@onready var markers = $SpawnMarkers.get_children()

#Enemy Related Variables
@export var bucko_scene: PackedScene
@export var elder_bucko1: PackedScene
@export var elder_bucko2: PackedScene
@export var elder_bucko3: PackedScene
@onready var spawn_timer = $SpawnTimer
@onready var wave2_timer = $Wave2Spawner
@onready var wave3_timer = $Wave3Spawner


var wave_ended: bool
var wave_spawn_ended: bool

func _on_VisibilityNotifier2D_screen_exited():
	set_physics_process(false)

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)

func play_transition():
	$WaveTileMapLayer.visible = false
	color_rect.color = Color(0, 0, 0, 1)
	color_rect.visible = true
	await get_tree().process_frame
	await get_tree().process_frame
	transition.play("fade_out")
	await transition.animation_finished
	$CanvasLayer.layer = 0
	color_rect.visible = false
	$WaveTileMapLayer.visible = true


func _ready() -> void:

	await play_transition()
	print(Globals.true_end, 'true end')
	print(Globals.good_end, 'good end')
	print(Globals.bad_end, 'bad end')
	
	if Globals.wave_1:
		Globals.defeated_mobs = Globals.W1_MAX_ENEMY_COUNT
	elif !Globals.wave_1 and !Globals.wave_3: #and Globals.wave_2
		Globals.defeated_mobs = Globals.W2_MAX_ENEMY_COUNT
	elif Globals.wave_3:
		Globals.defeated_mobs = Globals.W3_MAX_ENEMY_COUNT

func _process(_delta: float) -> void:
	if Globals.weapon_selected and !Globals.game_ready:
		game_start()
	elif current_wave == 1 and enemy_deaths == Globals.W1_MAX_ENEMY_COUNT and boss_one_is_dead:
		wave2_start()
	elif current_wave == 2 and enemy_deaths == Globals.W2_MAX_ENEMY_COUNT and boss_two_is_dead:
		wave3_start()
	#elif current_wave == 3 and enemy_deaths == Globals.W3_MAX_ENEMY_COUNT and boss_three_is_dead:
		#await game_messages.ending_text()

# In game dialogues
func run_wave_dialogue(wave, part):
	var dialogue = dialogues.instantiate()
	add_child(dialogue)
	
	get_tree().paused = true
	print('game paused?: ', get_tree().paused)
	await dialogue.wave_dialogue(wave, part)
	get_tree().paused = false
	print('game paused?: ', get_tree().paused)


#Wave Starters 
func wave_text_starters(wave_count):
	await game_messages.wave_text(wave_count)
	
	
func game_start():
	Globals.game_ready = true
	Globals.wave_1 = true
	current_wave += 1
	Globals.current_wave = current_wave
	await wave_text_starters(current_wave)
	
	spawn_timer.start()

func wave2_start():
	enemy_deaths = 0
	enemies_spawn = 0
	Globals.wave_1 = false
	Globals.wave_2 = true
	Globals.defeated_mobs = Globals.W2_MAX_ENEMY_COUNT
	current_wave += 1
	Globals.current_wave = current_wave
	await wave_text_starters(current_wave)
	
	wave2_timer.start()

	
func wave3_start():
	enemy_deaths = 0
	enemies_spawn = 0
	Globals.wave_2 = false
	Globals.wave_3 = true
	Globals.defeated_mobs = Globals.W3_MAX_ENEMY_COUNT
	current_wave += 1
	Globals.current_wave = current_wave
	await wave_text_starters(current_wave)
	
	wave3_timer.start()

#Wave Timers
func _on_spawn_timer_timeout() -> void:
	if current_wave == 1 and enemy_deaths == Globals.W1_MAX_ENEMY_COUNT and boss_one_is_dead:
		spawn_timer.stop()

		#proceed to wave 2
		#some cut scene 
	
	if enemies_spawn >= Globals.W1_MAX_ENEMY_COUNT:
		spawn_timer.stop()
		return
		
	if active_enemies >= MAX_SPAWN_SIZE:
		return

	enemy_spawn()
	enemies_spawn += 1
	

func _on_wave_2_spawner_timeout() -> void:
	
	if current_wave == 2 and enemy_deaths == Globals.W2_MAX_ENEMY_COUNT and boss_two_is_dead:
		wave2_timer.stop()
		#some cut scene 
	elif enemies_spawn >= Globals.W2_MAX_ENEMY_COUNT:
		wave2_timer.stop()
		return	
	elif active_enemies >= MAX_SPAWN_SIZE:
		return
	else:
		enemy_spawn()
		enemies_spawn += 1
		
func _on_wave_3_spawner_timeout() -> void:
	if current_wave == 3 and enemy_deaths == Globals.W3_MAX_ENEMY_COUNT and boss_three_is_dead:
		print_debug('game done')
		wave3_timer.stop()
		await game_messages.ending_text()
		return
	
	if enemies_spawn >= Globals.W3_MAX_ENEMY_COUNT:
		spawn_timer.stop()
		return
		
	if active_enemies >= MAX_SPAWN_SIZE:
		return

	enemy_spawn()
	enemies_spawn += 1

#Spawners And Bosses
func spawn_near_target():

	var valid_points = []
	for marker in markers:
		var distance = marker.global_position.distance_to($Ami.global_position)
		if distance >= MIN_DISTANCE and distance <= MAX_DISTANCE:
			valid_points.append(marker)
	return valid_points

func enemy_spawn():
	#var test_spawn = get_random_spawn_point_around_viewport()
	
	var player = get_node("Ami")
	var valid_spoints = spawn_near_target()
	#if valid_spoints.size() == 0: 
		#print('no valid points')
		#print("Trying to spawn. Valid points:", valid_spoints.size())
		#return
	
	#var spawn_marker = $SpawnMarkers.get_children() 
	var spawn_location = valid_spoints[randi() % valid_spoints.size()]
	var bucko = bucko_scene.instantiate()
	bucko.position = spawn_location.global_position
	if player:
		bucko.target_dir = player
	$EnemySpawner.add_child(bucko)
	active_enemies += 1
	bucko.connect("died", enemy_died)
	print('active enemies: ',active_enemies)
	
	var debug = ColorRect.new()
	debug.color = Color(1, 0, 0, 0.5)
	debug.size = Vector2(10, 10)
	debug.position = spawn_location.global_position
	add_child(debug)
	
func enemy_died():
	active_enemies -= 1
	Globals.defeated_mobs -= 1
	enemy_deaths += 1
	print(enemy_deaths, 'enemy death')
	
		#Boss Summons
	if current_wave == 1 and enemy_deaths >= Globals.W1_MAX_ENEMY_COUNT / 2 and !boss_is_summoned:
		await run_wave_dialogue(1, 1)
		spawn_boss()
		print('first boss summoned')
		boss_is_summoned = true
	if current_wave == 2 and enemy_deaths >= Globals.W2_MAX_ENEMY_COUNT / 2 and !boss2_is_summoned:
		spawn_second_boss()
		print('second boss summoned')
		boss2_is_summoned = true
	if current_wave == 3 and enemy_deaths >= Globals.W3_MAX_ENEMY_COUNT / 2 and !boss3_is_summoned:
		spawn_final_boss()
		print('3rd boss summoned')
		boss3_is_summoned = true

func spawn_boss():
	var player = get_node("Ami")

	var valid_spoints = spawn_near_target()
	#if valid_spoints.size() == 0: 
		#print('no valid points')
		#print("Trying to spawn. Valid points:", valid_spoints.size())
		#return

	var spawn_marker = valid_spoints[randi() % valid_spoints.size()]
	var elder1 = elder_bucko1.instantiate()
	elder1.position = spawn_marker.global_position
	if player:
		elder1.target_dir = player
	add_child(elder1)
	active_enemies += 1
	elder1.connect("died", enemy_died)
	elder1.connect("boss_one_died", boss_death)

func boss_death():
	boss_one_is_dead = true
	print('boss 1 is dead?', boss_one_is_dead)
	
func boss_two_death():
	boss_two_is_dead = true 

func boss_three_death():
	boss_three_is_dead = true
	
func spawn_second_boss():
	var player = get_node("Ami")
	
	var valid_spoints = spawn_near_target()

	var spawn_marker = valid_spoints[randi() % valid_spoints.size()]
	var elder2 = elder_bucko2.instantiate()
	elder2.position = spawn_marker.global_position
	if player:
		elder2.target_dir = player
	add_child(elder2)
	active_enemies += 1
	elder2.connect("died", enemy_died)
	elder2.connect("boss_two_died", boss_two_death)

func spawn_final_boss():
	var player = get_node("Ami")
	
	var valid_spoints = spawn_near_target()

	var spawn_marker = valid_spoints[randi() % valid_spoints.size()]
	var elder3 = elder_bucko3.instantiate()
	elder3.position = spawn_marker.global_position
	if player:
		elder3.target_dir = player
	add_child(elder3)
	active_enemies += 1
	elder3.connect("died", enemy_died)
	elder3.connect("boss_three_died", boss_three_death)


#Player mechanics
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
		Globals.weapon_selected = true
		
	elif Globals.wep_hanger == true:
		var weapon = get_weapon(get_hanger_proj)
		weapon.position = pos
		weapon.rotation_degrees = rad_to_deg(direction.angle()) + 90
		weapon.direction = direction
		$Projectiles.add_child(weapon)
		Globals.weapon_selected = true
		
	elif Globals.wep_embrace == true:
		var weapon = get_embrace_proj.instantiate() as Area2D
		weapon.position = pos
		$Projectiles.add_child(weapon)
		Globals.weapon_selected = true


func _spawn_dmg_text(damage):
	var popup = dmg_popup.instantiate() 

	popup.global_position = $Ami.get_global_position()
	
	$InGameUI.add_child(popup)
	popup.show_damage(damage)
	

func _on_ami_damage_received(damage: Variant) -> void:
	_spawn_dmg_text(damage)



#func proceed_to_next_wave():
	#
	#if Globals.current_wave == 0:
		#current_wave += 1
		#print('current wave: ', current_wave)
		#has_spawn_started = true
		#spawn_mobs(5, 20)
		#has_spawn_started = false
		
		
#func start_spawn(timer, amount: int, total_rounds: int):
#
	#var counter = 0
	#
	#if current_wave == 1 and spawn_queue_size < MAX_SPAWN_SIZE and current_deaths < W1_MAX_ENEMY_COUNT:
		##queue_size(MAX_SPAWN_SIZE, total_rounds, amount, W1_MAX_ENEMY_COUNT)
		#var spawn_marker = $SpawnMarkers.get_children()
		#var spawn_location = spawn_marker[randi() % spawn_marker.size()]
		#var bucko = bucko_scene.instantiate()
		#bucko.position = spawn_location.global_position
		#if player:
			#bucko.target_dir = player
		#add_child(bucko)
		#has_spawn_ended = true
		#counter += 1
		#print('spawn count: ', counter)
		#await get_tree().create_timer(timer).timeout
		#
	#
	#unless timer not stop, continue spawn until reach max wave count 

	#
#
#func move_to_next_wave():
#
	#if current_wave == 0 and Globals.wave_1:
		#current_wave += 1
		#Globals.current_wave = current_wave
		#mobs_spawn("bucko", 5.0, 20)
		#
	#if current_wave == 1 and max_enimies1 == current_deaths:
		##add animation here 
		#if current_wave != 0:
			#
			#Globals.moving_to_next_wave = true
			#current_wave += 1
			#Globals.current_wave = current_wave
			#wave_spawn_ended = false
		##wave_ended = false
		#await get_tree().create_timer(1).timeout
#
		#mobs_spawn("bucko", 5.0, 26)
	#elif current_wave == 2 and max_enimies2 == current_deaths:
		#wave_spawn_ended = false
		#Globals.moving_to_next_wave = true
		#current_wave += 1
		#Globals.current_wave = current_wave
		#wave_spawn_ended = false
		##wave_ended = false
		#await get_tree().create_timer(1).timeout
	#
		#mobs_spawn("bucko", 5.0, 30)
	#elif current_wave == 3 and max_enimies3 == current_deaths:
		#Globals.game_end = true


#func mobs_spawn(type, multiplier, mob_spawns):
	#if wave_spawn_ended:
		#return
	#wave_spawn_ended = true
	#
	#if current_wave == 1:
		#var mob_amount = int(multiplier * mob_spawns) #20 * 5 = 100 mob_spawn 20
		#var wait_time: float = 2.0
		#var spawn_rounds = int(ceil(mob_amount / mob_spawns))
		#spawn_mob(type, mob_spawns, spawn_rounds, wait_time)
		#
	#if current_wave == 2:
		#var mob_amount = int(multiplier * mob_spawns) #26 * 5 = 130 mob_spawn 26
		#var wait_time: float = 2.0
		#var spawn_rounds = int(ceil(mob_amount / mob_spawns))
		#spawn_mob(type, mob_spawns, spawn_rounds, wait_time)
		#
	#if current_wave == 3:
		#var mob_amount = int(multiplier * mob_spawns) #30 * 5 = 150 mob_spawn 30
		#var wait_time: float = 2.0
		#var spawn_rounds = int(ceil(mob_amount / mob_spawns))
		#spawn_mob(type, mob_spawns, spawn_rounds, wait_time)
		#
	#
#func spawn_mob(type, enemy_count, spawn_rounds, wait_time):
	#var player = get_node("Ami")
	#
	#if type == "bucko":
		#var rand_marker = $SpawnMarkers.get_children()
		#var spawn_loc = rand_marker[randi() % rand_marker.size()]
		#var counter = 0
		#
		## manual debugg - if reached enemy count stop spawning or 
		#for r in range(spawn_rounds):
			#for i in range(enemy_count):
				#counter += 1
				#print('one bucko spawned: ', counter)
				#var buckos = bucko_scene.instantiate()
				#buckos.global_position = spawn_loc.global_position
				#if player:
					#buckos.target_dir = player
				#add_child(buckos)
				#await get_tree().create_timer(wait_time).timeout
	#wave_spawn_ended = true
	#wave_spawn_ended = false
		#
