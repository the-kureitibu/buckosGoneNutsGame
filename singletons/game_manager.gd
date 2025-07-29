extends Node2D

#Ending Selectors 
var true_end: bool = false
var bad_end: bool = false
var good_end: bool = false

#Wave States
var wave_one: bool = false
var wave_two: bool = false
var wave_three: bool = false
var current_wave: int = 0  #Set this at weapon selection 
var max_active_enemies: int 
var game_started := false 
var weapon_select := false
var pre_game_start:= false
var restart_game := false
var back_to_menu_clicked := false 

#Signals 
signal update_wave_count 
signal update_wave_quota

func reset_stats():
	PlayerManager.on_rage = false
	game_started = false
	weapon_select = false
	pre_game_start = false
	wave_one = false
	wave_two = false
	wave_three = false
	true_end = false
	bad_end = false
	good_end = false
	_waves = preload("res://resources/waves_manager.tres")
	current_wave_mobs = _waves.w1_max_mobs
	current_wave_quota = _waves.w1_max_mobs
	current_wave = 1
	max_active_enemies = _waves.max_active_mobs
	

var current_wave_quota: int = 0: 
	set(value): 
		current_wave_quota = value
		update_wave_quota.emit()

var _waves: WaveStats
var current_wave_mobs: int = 0:
	set(value):
		current_wave_mobs = value
		update_wave_count.emit()

func _ready() -> void:
	_waves = preload("res://resources/waves_manager.tres")
	current_wave_mobs = _waves.w1_max_mobs
	current_wave_quota = _waves.w1_max_mobs
	current_wave = 1
	max_active_enemies = _waves.max_active_mobs

func wave_setter(wave_number: int):
	match wave_number: 
		1:
			wave_one = true
			current_wave_mobs = _waves.w1_max_mobs
		2:
			wave_two = true
			current_wave = 2
			current_wave_mobs = _waves.w2_max_mobs
			current_wave_quota = _waves.w2_max_mobs
			wave_one = false
		3: 
			wave_three = true
			current_wave = 3
			current_wave_mobs = _waves.w3_max_mobs
			current_wave_quota = _waves.w3_max_mobs
			wave_two = false
			wave_one = false
