extends Node2D

func apply_damage():
	print('i got hit')






func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('player_projectiles'):
		if area.has_method("return_player"):
			var player = area.return_player()
			print(player)
			if player and 'get_rage_damage' in player and PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGING:
				var samp = player.get_rage_damage()
				print(samp, 'should be damage here')
				print('this working?')
				#var damage = player.get_damaged()
				#print_debug(damage)
	#if area.is_in_group('player_projectiles') and 'damage':
		#damage = area.damage
