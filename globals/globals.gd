extends Node


signal rage_activated
signal stat_change
signal change_wave
signal change_mobs_count
signal health_change

var game_ready: bool = false
var game_end: bool = false
var weapon_selected: bool = false

#Weapons Dictionaries 
var hanger_wep = {
	"Damage": 25,
	"Max_damage": 50
}

var exchu_wep = {
	"Damage": 20,
	"Max_damage": 60
	#Add slow effect
	#Add max slow effect 
}

var embrace_wep = {
	"Damage": 25,
	"Max_damage": 35
	#Implement Stops per seconds 
	#Implement max stop per seconds 
}

#Enemy Dictionaries
var bucko = {
	"Health": 70,
	"Damage": 10
	#max damage if applicable
	#skill cd if applicable 
}

var elder_bucko1 = {
	"Health": 500,
	"Damage": 20
	#max damage if applicable
	#skill cd if applicable 
}

var elder_bucko2 = {
	"Health": 600,
	"Damage": 20
	#max damage if applicable
	#skill cd if applicable 
}

var elder_bucko3 = {
	"Health": 600,
	"Damage": 20
	#max damage if applicable
	#skill cd if applicable 
}


#Player States 
enum RageState {
	IDLE,
	RAGING,
	COOLDOWN,
	RAGEDONE,
}

var rage_state = RageState.IDLE

enum RageStat {
	RAGE_ON,
	COOLING_DOWN,
	RAGE_OFF
}

var rage_stats = RageStat.RAGE_OFF

enum PlayerState {
	CAN_ATTACK,
	CANT_ATTACK,
	IDLE
}

var player_state =  PlayerState.IDLE

#Player and enemies stuff
var t: String = 'rage activated'
var player_pos: Vector2
var ami_health: float = 100.0

# Weapon choices 
var wep_hanger: bool = false
var wep_embrace: bool = false
var wep_exchu: bool = false

# max range indication
var outside_range: bool = false #to be implemented

# Waves

const W1_MAX_ENEMY_COUNT: int = 100
const W2_MAX_ENEMY_COUNT: int = 130
const W3_MAX_ENEMY_COUNT: int = 150

var defeated_mobs: int:
	set(value):
		defeated_mobs = value
		change_mobs_count.emit()


var moving_to_next_wave: bool = false
var current_wave
var wave_1: bool = true:
	set(value):
		wave_1 = value
		change_wave.emit()
var wave_2: bool = false:
	set(value):
		wave_2 = value
		change_wave.emit()
var wave_3: bool = false:
	set(value):
		wave_3 = value
		change_wave.emit()

# Specials
var rage: int:
	set(value):
		rage = value
		stat_change.emit()
		
var rage_die_down: int = 15
const max_rage: int = 15

var rage_on: bool = false:
	set(value):
		rage_on = value 
		rage_activated.emit()
		print(t)

# Stats Update 
var health_damaged: int:
	set(value):
		health_damaged = value
		health_change.emit()
