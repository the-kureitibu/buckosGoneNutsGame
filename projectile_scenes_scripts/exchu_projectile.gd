extends PlayerProjectiles

var speed := 100
var direction: Vector2 = Vector2.ZERO
var damage = WeaponsManager.exchu_projectile.Damage


func _process(delta: float) -> void:
	
	position += speed * direction * delta


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
