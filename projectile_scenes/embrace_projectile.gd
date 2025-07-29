extends PlayerProjectiles


var damage: int
var life_span_timer: float
var base_scale = scale
var raging: bool = false
@onready var projectile_audio_stream = $AudioStreamPlayer2D
@onready var collision_polygon2d = $CollisionPolygon2D
@onready var hit_polys: Array = [
	$"Frame 1".polygon,
	$"Frame 2".polygon,
	$"Frame 3".polygon,
	$"Frame 4".polygon
]

func _ready() -> void:

	life_span_timer = weapon_stats.life_span

func set_hitbox_poly(current_frame: int):
	match current_frame:
		0: collision_polygon2d.polygon = hit_polys[0]
		1: collision_polygon2d.polygon = hit_polys[1]
		2: collision_polygon2d.polygon = hit_polys[2]
		3: collision_polygon2d.polygon = hit_polys[3]

func set_initial_stats(weapon: WeaponStats, is_raging: bool):
	if is_raging:
		damage = weapon.damage + weapon.rage_damage

	else:
		damage = weapon.damage



func _process(_delta: float) -> void:
	

	if PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGING:
		var target_scale = scale + weapon_stats.rage_scale
		var tween = create_tween()
		tween.tween_property(self, "scale", target_scale, life_span_timer)
		$AnimationPlayer.play("normal_attack")
	else:
		$AnimationPlayer.play("normal_attack")

	await get_tree().create_timer(life_span_timer).timeout
	queue_free()
	


func _on_area_entered(area: Area2D) -> void:
	projectile_audio_stream.play()
	trigger_debuff(area, weapon_stats)
	rage_getter(area, weapon_stats)


func _on_rage_cooling_timeout() -> void:
	raging = false


func _on_stats_revert_timeout() -> void:
	pass
