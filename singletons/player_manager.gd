extends Node

#Signals
signal health_change
signal rage_change

#var player_stats: PlayerStats
const MAX_RAGE: int = 10
var on_rage: bool = false
var player_rage_state = PlayerStateManager.RageState.IDLE
var runtime_player_stats: PlayerStats

var weapon_index: int = 0

#
func _ready() -> void:
	runtime_player_stats = preload("res://resources/player_stats_manager.tres")
	#max_rage = player_stats.max_rage

var rage := 0:
	set(value):
		rage = value
		rage_change.emit()

func apply_damage(damage, player_health):
	player_health -= damage
	player_health = clamp(player_health, 0, 250.0)
	health_change.emit()
