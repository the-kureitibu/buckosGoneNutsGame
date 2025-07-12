extends PlayerProjectiles

var damage = WeaponsManager.embrace_projectile.Damage 
var life_span_timer := 2.0


func _process(delta: float) -> void:
	
	await get_tree().create_timer(life_span_timer).timeout
	queue_free()
		
func trigger_debuff(area):
	var duration = WeaponsManager.embrace_projectile.Snare_duration
	var multiplier = 0
	var added_damage = 0
	
	if area.is_in_group('enemy_hurtbox') and 'can_debuff':
		var source_getter = area.get_parent().has_method("apply_debuff")
		var source = area.get_parent()
		
		if source_getter:
			source.call("apply_debuff", "snare", duration, multiplier, added_damage)


func _on_area_entered(area: Area2D) -> void:
	trigger_debuff(area)
