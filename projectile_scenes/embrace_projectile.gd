extends PlayerProjectiles


var damage: int
var life_span_timer: float
var wep_scale: Vector2 = Vector2(1, 1)
var base_scale = wep_scale
var raging: bool = false


func _ready() -> void:
	damage = weapon_stats.damage
	life_span_timer = weapon_stats.life_span

func _process(delta: float) -> void:
	
	await get_tree().create_timer(life_span_timer).timeout
	queue_free()
	apply_rage_modifier(weapon_stats)

func apply_rage_modifier(weapon: WeaponStats):
	if PlayerManager.on_rage and !raging:
		raging = true
		damage += weapon.rage_damage
		print(damage)
		base_scale = weapon.rage_scale
		
		await get_tree().create_timer(5.0).timeout
		damage -= weapon.rage_damage
		base_scale = wep_scale
		$RageCooling.start()


func _on_area_entered(area: Area2D) -> void:
	trigger_debuff(area, weapon_stats)
	rage_getter(area, weapon_stats)


func _on_rage_cooling_timeout() -> void:
	raging = false
