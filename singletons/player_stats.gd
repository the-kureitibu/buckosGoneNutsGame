extends Resource

class_name PlayerStats

@export var weapon_listings: Array[WeaponStats] = [
	preload("res://resources/hanger_projectile.tres"),
	preload("res://resources/embrace_projectile.tres"),
	preload("res://resources/exchu_projectile.tres")
]

@export var selected_weapon = weapon_listings[1]

@export var base_attack_cd: float = 0.0
@export var base_health: float = 0.0
@export var base_attack_speed: float = 0.0
@export var base_speed: float = 0.0
@export var repulsion_force: float = 0.0
@export var max_rage: int = 0
@export var rage_duration: float = 0.0
