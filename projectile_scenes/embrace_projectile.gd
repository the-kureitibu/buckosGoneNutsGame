extends PlayerProjectiles


var damage: int
var life_span_timer: float

func _ready() -> void:
	damage = weapon_stats.damage
	life_span_timer = weapon_stats.life_span

func _process(delta: float) -> void:
	
	await get_tree().create_timer(life_span_timer).timeout
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	trigger_debuff(area, weapon_stats)
