extends Node


signal rage_activated
signal stat_change
signal change_wave

var game_ready: bool = false

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
var bucko_health: float = 150.0
var elder_bucko_health: float = 400.0

# Weapon choices 
var wep_hanger: bool = false
var wep_embrace: bool = false
var wep_exchu: bool = false

# max range indication
var outside_range: bool = false

# Waves
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
#
#var raging: bool = true:
	#set(value):
		#raging = value
		#rage_ongoing.emit()
