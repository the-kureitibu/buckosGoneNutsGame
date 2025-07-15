extends Node

class_name StatsModifier

var base_value: float
var bonus_flat: float = 0.0
var bonus_percent: float = 0.0


func get_modified_value():
	return (base_value + bonus_flat) * (1.0 - bonus_percent)
	
