extends PlayerProjectiles

var damage: float
var speed: float
var direction: Vector2 = Vector2.ZERO
var range_starting_pos: Vector2
var max_range: float



func _ready() -> void:
	range_starting_pos = global_position
	damage = weapon_stats.damage
	speed = weapon_stats.projectile_speed
	max_range = weapon_stats.range
	
func range_handler(pos):
	if global_position.distance_to(range_starting_pos) >= max_range:
		queue_free()

func _process(delta: float) -> void:
	
	position += direction * speed * delta
	
	range_handler(range_starting_pos)


func _on_area_entered(area: Area2D) -> void:
	trigger_debuff(area, weapon_stats)
