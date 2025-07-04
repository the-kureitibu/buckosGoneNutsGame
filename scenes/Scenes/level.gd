extends Node2D

# Weapon Projectiles Scenes
var get_hanger_proj: PackedScene = preload("res://projectiles/projectile_hanger.tscn")
var get_exchu_proj: PackedScene = preload("res://projectiles/exchu_li_bladder.tscn")
var get_embrace_proj: PackedScene = preload("res://projectiles/ami_embrace.tscn")

# Wave States
var ROUND_COUNT = 5
var resume_spawn_treshold = 20
var active_enemies = 0
var enemies_spawn = 0
var enemy_deaths: int
var MAX_SPAWN_SIZE: int = 30
var current_wave = 0

var has_spawn_ended: bool = false
var has_spawn_started: bool = false


#Enemy Related Variables
@export var bucko_scene: PackedScene
@export var elder_bucko1: PackedScene
@export var elder_bucko2: PackedScene
@onready var spawn_timer = $SpawnTimer



var wave_ended: bool
var wave_spawn_ended: bool

func _ready() -> void:
	spawn_boss()
	if Globals.wave_1:
		Globals.defeated_mobs = Globals.W1_MAX_ENEMY_COUNT
	elif !Globals.wave_1 and !Globals.wave_3 and Globals.wave_2:
		Globals.defeated_mobs = Globals.W2_MAX_ENEMY_COUNT
	elif Globals.wave_3:
		Globals.defeated_mobs = Globals.W3_MAX_ENEMY_COUNT

func _process(_delta: float) -> void:
	if Globals.weapon_selected and !Globals.game_ready:
		game_start()
		
func game_start():
		Globals.game_ready = true
		Globals.wave_1 = true
		current_wave += 1
		Globals.current_wave = current_wave
		
		spawn_timer.start()
		print('Time Started?', !spawn_timer.is_stopped())
	
func _on_spawn_timer_timeout() -> void:
	if current_wave == 1 and enemy_deaths == Globals.W1_MAX_ENEMY_COUNT:
		#spawn_timer.stop()
		#proceed to wave 2
		pass
	
	if enemies_spawn >= Globals.W1_MAX_ENEMY_COUNT:
		spawn_timer.stop()
		return
		
	if active_enemies >= MAX_SPAWN_SIZE:
		return

	enemy_spawn()
	enemies_spawn += 1
	

func enemy_spawn():
	var player = get_node("Ami")
	
	var spawn_marker = $SpawnMarkers.get_children()
	var spawn_location = spawn_marker[randi() % spawn_marker.size()]
	var bucko = bucko_scene.instantiate()
	bucko.position = spawn_location.global_position
	if player:
		bucko.target_dir = player
	add_child(bucko)
	active_enemies += 1
	bucko.connect("died", enemy_died)
	print('active enemies: ',active_enemies)
	
func enemy_died():
	active_enemies -= 1
	Globals.defeated_mobs -= 1

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
func spawn_boss():
	var player = get_node("Ami")

	
	var spawn_marker = $SpawnMarkers/Marker2D10
	var elder1 = elder_bucko1.instantiate()
	elder1.position = spawn_marker.global_position
	if player:
		elder1.target_dir = player
	add_child(elder1)
	active_enemies += 1
	elder1.connect("died", enemy_died)
	

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


#func _on_ui_weapon_selected() -> void:
	#Globals.game_ready = true
