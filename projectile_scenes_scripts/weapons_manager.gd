extends Node

@export var hanger_projectile: WeaponStats
@export var embrace_projectile: WeaponStats
@export var exchu_projectile: WeaponStats

var weapon_selected: String = ""

@export var weapon_list: Dictionary = {
	"hanger" = preload("res://resources/hanger_projectile.tres"),
	"embrace" = preload("res://resources/embrace_projectile.tres"),
	"exchu" = preload("res://resources/exchu_projectile.tres")
}

var exchulibladder: bool = false
var hanger: bool = false
var embrace: bool = false
