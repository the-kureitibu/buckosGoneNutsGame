extends PlayerProjectiles

var speed: float
var damage: float
var max_range: float
var direction: Vector2 = Vector2.UP
var range_starting_pos: Vector2 


func _ready() -> void:
	range_starting_pos = global_position
	#speed = weapon_stats.projectile_speed
	#damage = weapon_stats.damage
	max_range = weapon_stats.project_range
	range_handler(range_starting_pos)


func range_handler(pos):
	if global_position.distance_to(range_starting_pos) >= max_range:
		queue_free()


func set_initial_stats(weapon: WeaponStats, is_raging: bool):
	if is_raging:
		speed = weapon.projectile_speed + weapon.rage_proj_speed
		damage = weapon.damage + weapon.rage_damage
		print('norm stats', ' speed: ', speed, ' damage: ', damage)
	else:
		speed = weapon.projectile_speed
		damage = weapon.damage
		print('norm stats', ' speed: ', speed, ' damage: ', damage)


func _process(delta: float) -> void:

	position += direction * speed * delta
	
	range_handler(range_starting_pos)


func _on_area_entered(area: Area2D) -> void:

	trigger_debuff(area, weapon_stats)
	rage_getter(area, weapon_stats)
