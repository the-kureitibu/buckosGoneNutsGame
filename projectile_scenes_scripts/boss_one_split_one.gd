extends Area2D


@export var stats: EnemyStats
@onready var max_range = stats.attack_range

var starting_position: Vector2 
var direction: Vector2 = Vector2.ZERO
var speed := 300.0
@onready var damage = stats.damage

#Attack Identifier
func id_elder_one():
	return
	

func _process(delta: float) -> void:
	
	global_position += direction * speed * delta
	
	$AnimationPlayer.play("main_attack")
	var travelled = global_position.distance_to(starting_position)
	if travelled >= max_range:
		queue_free()
