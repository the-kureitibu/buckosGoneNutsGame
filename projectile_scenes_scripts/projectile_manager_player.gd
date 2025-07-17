extends Area2D

class_name PlayerProjectiles

@export var weapon_stats: WeaponStats

func trigger_debuff(area: Node2D, weapon: WeaponStats):
	var duration = 0.0
	var multiplier = 0.0
	var added_damage = 0.0
	var debuff_type = weapon.debuff_type

	if WeaponsManager.weapon_selected == "hanger":
		if PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGING:
			duration = weapon.bleed_duration + weapon.rage_bleed_duration
			added_damage = weapon.bleed_damage + weapon.rage_bleed_damage
		else:
			duration = weapon.bleed_duration 
			added_damage = weapon.bleed_damage
	if WeaponsManager.weapon_selected == "exchu":
		if PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGING:
			duration = weapon.slow_duration + weapon.rage_slow_duration
			multiplier = weapon.debuff_multiplier + weapon.rage_debuff_multiplier
		else: 
			duration = weapon.slow_duration
			multiplier = weapon.debuff_multiplier
	if WeaponsManager.weapon_selected == "embrace":
		if PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGING:
			duration = weapon.snare_duration + weapon.rage_snare_duration
		else: 
			duration = weapon.snare_duration

	

		#match debuff_type:
			#"bleed":
				#if PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGING:
					#duration = weapon.bleed_duration + weapon.rage_bleed_duration
					#added_damage = weapon.bleed_damage + weapon.rage_bleed_damage
				#else:
					#duration = weapon.bleed_duration 
					#added_damage = weapon.bleed_damage
					#print('add dmg from parent: ', added_damage)
			#"slow":
				#if PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGING:
					#duration = weapon.slow_duration + weapon.rage_slow_duration
					#multiplier = weapon.debuff_multiplier + weapon.rage_debuff_multiplier
				#else: 
					#duration = weapon.slow_duration
					#multiplier = weapon.debuff_multiplier
			#"snare":
				#if PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGING:
					#duration = weapon.snare_duration + weapon.rage_snare_duration
				#else: 
					#duration = weapon.snare_duration
	#
	if area.is_in_group('enemy_hurtbox') and 'can_debuff':
		var source_getter = area.get_parent().has_method("apply_debuff")
		var source = area.get_parent()
		
		if source_getter:
			source.call("apply_debuff", debuff_type, duration, multiplier, added_damage)
			print('db: ', debuff_type, 'dur:', duration, 'multi: ', multiplier, 'added dmg: ', added_damage)


func rage_getter(area: Node2D, weapon: WeaponStats):
	if area.is_in_group('enemy_hurtbox') and !PlayerManager.on_rage:
		PlayerManager.rage += weapon.rage_gain
		PlayerManager.rage = clamp(PlayerManager.rage, 0, 10)
		
		if PlayerManager.rage >= PlayerManager.MAX_RAGE and PlayerManager.player_rage_state == PlayerStateManager.RageState.IDLE: 
			PlayerManager.on_rage = true
			PlayerManager.player_rage_state = PlayerStateManager.RageState.RAGING
