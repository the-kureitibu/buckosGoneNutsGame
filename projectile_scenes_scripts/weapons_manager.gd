extends Node

#Weapon Stats
var hanger_projectile = {
	"Damage" = 25,
	"Attack_speed" = 0.25,
	"Range" = 200.0,
	"Bleed_damage" = 2.5,
	"Bleed_duration" = 1.0
}

var exchu_projectile = {
	"Damage" = 20,
	"Attack_speed" = 0.15,
	"Range" = 180.0,
	"Slow_duration" = 1.0,
	"Slow_multiplier" = 0.2
}

var embrace_projectile = {
	"Damage" = 30,
	"Attack_speed" = 0.25,
	"Snare_duration" = 1.0
}

var exchulibladder: bool = false
var hanger: bool = false
var embrace: bool = false
