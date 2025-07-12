extends PlayerProjectiles

var speed := 100
var direction: Vector2 = Vector2.ZERO
var damage = WeaponsManager.exchu_projectile.Damage
var range_starting_pos: Vector2 
var max_range = WeaponsManager.exchu_projectile.Range

func _ready() -> void:
	range_starting_pos = global_position

func _process(delta: float) -> void:
	
	position += direction * speed * delta
	
	#range_handler(range_starting_pos)
	if global_position.distance_to(range_starting_pos) >= max_range:
		queue_free()

func trigger_debuff(area):
	var duration = WeaponsManager.exchu_projectile.Slow_duration
	var multiplier = WeaponsManager.exchu_projectile.Slow_multiplier
	var added_damage = 0.0
	
	if area.is_in_group('enemy_hurtbox') and 'can_debuff':
		var source_getter = area.get_parent().has_method("apply_debuff")
		var source = area.get_parent()
		
		if source_getter:
			source.call("apply_debuff", "slow", duration, multiplier, added_damage)


func _on_area_entered(area: Area2D) -> void:
	trigger_debuff(area)
