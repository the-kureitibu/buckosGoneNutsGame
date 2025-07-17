extends Node

#Signals
signal health_change()
signal rage_change
signal rage_state_changed

#var player_stats: PlayerStats
const MAX_RAGE: int = 10
var on_rage: bool = false
#var player_rage_state = PlayerStateManager.RageState.IDLE
var runtime_player_stats: PlayerStats

var weapon_index: int = 0
var player_rage_state = PlayerStateManager.RageState.IDLE
var player_current_health := 0.0:
	set(value):
		player_current_health = value
		health_change.emit()

func _ready() -> void:
	runtime_player_stats = preload("res://resources/player_stats_manager.tres")

var try: String:
	set(value):
		try = value
		rage_state_changed.emit()

var rage := 0:
	set(value):
		rage = value
		rage_change.emit()

func apply_damage(player_health):
	print('current health, ', player_health)
	player_health = clamp(player_health, 0, 250.0) #somwhere here the health remains the same after the first damage
	player_current_health = player_health
