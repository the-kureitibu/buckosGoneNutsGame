extends PlayerProjectiles

var speed: float
var damage: float
var max_range: float
var direction: Vector2 = Vector2.UP
var range_starting_pos: Vector2 
@onready var projectile_audio_stream = $AudioStreamPlayer2D

func _ready() -> void:
	range_starting_pos = global_position
	max_range = weapon_stats.project_range
	#range_handler()
	play_sfx()


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


func _process(delta: float) -> void:

	position += direction * speed * delta
	$AnimationPlayer.play("normal_attack")
	range_handler()


func play_sfx():
	var sound = randf_range(-5.0, -2.0)
	projectile_audio_stream.volume_db = sound
	projectile_audio_stream.play()

	

func _on_area_entered(area: Area2D) -> void:

	trigger_debuff(area, weapon_stats)
	rage_getter(area, weapon_stats)
