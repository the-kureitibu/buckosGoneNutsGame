extends PlayerProjectiles

var speed := 100
var direction: Vector2 = Vector2.UP
var damage = WeaponsManager.hanger_projectile.Damage
var range_starting_pos: Vector2 
var max_range = WeaponsManager.hanger_projectile.Range

func _ready() -> void:
	range_starting_pos = global_position

func _process(delta: float) -> void:
	
	position += direction * speed * delta
	
	#range_handler(range_starting_pos)
	if global_position.distance_to(range_starting_pos) >= max_range:
		queue_free()


func _on_area_entered(area: Area2D) -> void:

	trigger_debuff(area)
