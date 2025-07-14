extends Area2D

class_name PlayerProjectiles

@export var weapon_stats: WeaponStats

func trigger_debuff(area: Node2D, weapon: WeaponStats):
	var duration = 0.0
	var multiplier = 0.0
	var added_damage = 0.0
	var debuff_type = weapon.debuff_type
	
	if debuff_type:
		match debuff_type:
			"bleed":
				duration = weapon.bleed_duration
				added_damage = weapon.bleed_damage
			"slow":
				duration = weapon.slow_duration
				multiplier = weapon.debuff_multiplier
			"snare":
				duration = weapon.snare_duration
	
	if area.is_in_group('enemy_hurtbox') and 'can_debuff':
		var source_getter = area.get_parent().has_method("apply_debuff")
		var source = area.get_parent()
		
		if source_getter:
			source.call("apply_debuff", debuff_type, duration, multiplier, added_damage)
			

func rage_getter():
	pass
