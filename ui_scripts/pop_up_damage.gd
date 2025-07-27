extends Node2D

func _show_damage(damage: int, regen: bool):
	print('is this working? ')
	if regen:
		$Label.text = "+ %s" % str(damage)
		modulate = Color(106.0/225.0, 210.0/225.0, 109.0/225.0, 1.0)
		$AnimationPlayer.play("pop_up")
	elif regen == false:
		$Label.text = "- %s" % str(damage)
		modulate = Color(200.0/225.0, 48.0/225.0, 63.0/225.0, 1.0) 
		$AnimationPlayer.play("pop_up")
