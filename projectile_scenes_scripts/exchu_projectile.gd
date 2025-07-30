extends PlayerProjectiles

var damage: float
var speed: float
var direction: Vector2 = Vector2.ZERO
var range_starting_pos: Vector2
var max_range: float
@onready var projectile_audio_stream = $AudioStreamPlayer2D


func _ready() -> void:
	range_starting_pos = global_position
	max_range = weapon_stats.project_range


	
func range_handler():
	if global_position.distance_to(range_starting_pos) >= max_range:
		queue_free()

func set_initial_stats(weapon: WeaponStats, is_raging: bool):
	if is_raging:
		speed = weapon.projectile_speed + weapon.rage_proj_speed
		max_range = weapon.project_range + weapon.rage_added_range
		damage = weapon.damage + weapon.rage_damage
	else:
		speed = weapon.projectile_speed
		damage = weapon.damage

func play_sfx():
	var sound = randf_range(-10.0, -5.0)
	projectile_audio_stream.volume_db = sound
	projectile_audio_stream.play()


func _process(delta: float) -> void:
	
	position += direction * speed * delta
	$AnimationPlayer.play("normal_attack")
	range_handler()

func _on_area_entered(area: Area2D) -> void:
	play_sfx()
	trigger_debuff(area, weapon_stats)
	rage_getter(area, weapon_stats)
	await get_tree().create_timer(0.5).timeout
	queue_free()
