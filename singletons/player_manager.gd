extends Node

#Signals
signal health_change
signal rage_change

var player_health := 250.0
var rage := 0

func apply_damage(damage):
	player_health -= damage
	print(damage, 'passed damage')
	print_debug(player_health)
	player_health = clamp(player_health, 0, 250.0)
	health_change.emit()
