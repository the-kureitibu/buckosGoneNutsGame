extends HealthBar

func _update_max_health():
	prog_bar.max_value = Globals.elder_bucko1.Health
	prog_bar.value = Globals.elder_bucko1.Health
	print(prog_bar.max_value)
	print(prog_bar.value)



func _on_elder_bucko_one_current_health(health_value: Variant) -> void:
	_update_health(health_value)
