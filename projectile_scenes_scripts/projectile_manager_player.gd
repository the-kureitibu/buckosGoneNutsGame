extends Area2D

class_name PlayerProjectiles



func trigger_debuff(area):
	var duration = WeaponsManager.hanger_projectile.Bleed_duration
	var multiplier = 0
	var added_damage = WeaponsManager.hanger_projectile.Bleed_damage
	
	if area.is_in_group('enemy_hurtbox') and 'can_debuff':
		var source_getter = area.get_parent().has_method("apply_debuff")
		var source = area.get_parent()
		
		if source_getter:
			source.call("apply_debuff", "bleed", duration, multiplier, added_damage)
