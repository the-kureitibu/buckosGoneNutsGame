extends Node


@export var enemy_list: Dictionary = {
	"bucko" = preload("res://resources/bucko.tres"),
	"boss_one" = preload("res://resources/boss_one.tres"),
	"boss_two" = preload("res://resources/boss_two.tres"),
	"boss_three" = preload("res://resources/boss_three.tres")
}

@onready var bucko_health = enemy_list.bucko.base_health
@onready var boss_one_health = enemy_list.boss_one.base_health
@onready var boss_two_health = enemy_list.boss_two.base_health

#func _ready() -> void:
	#print('in enemy manager ', bhealth2)
