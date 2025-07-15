extends PlayerProjectiles

var speed: float
var damage: float
var max_range: float
var direction: Vector2 = Vector2.UP
var range_starting_pos: Vector2 
var raging: bool = false

func _ready() -> void:
	range_starting_pos = global_position
	speed = weapon_stats.projectile_speed
	damage = weapon_stats.damage
	max_range = weapon_stats.project_range
	range_handler(range_starting_pos)

func range_handler(pos):
	if global_position.distance_to(range_starting_pos) >= max_range:
		queue_free()

func _process(delta: float) -> void:
	
	position += direction * speed * delta
	
	range_handler(range_starting_pos)
	apply_rage_modifier(weapon_stats)

func apply_rage_modifier(weapon: WeaponStats):
	if PlayerManager.on_rage and !raging:
		raging = true
		damage += weapon.rage_damage
		print(damage)
		speed += weapon.rage_atkspd
		
		await get_tree().create_timer(5.0).timeout
		damage -= weapon.rage_damage
		speed -= weapon.rage_atkspd
		$"RageCooling Timer".start()
		
		#Handle cooling down rage here or on player 
func _on_area_entered(area: Area2D) -> void:

	trigger_debuff(area, weapon_stats)
	rage_getter(area, weapon_stats)


func _on_body_entered(body: Node2D) -> void:
	var tar = body.get_parent().get_node("StaticBody2D").has_method("apply_damage")
	
	if tar:
		tar.apply_damage()
	queue_free()


func _on_rage_cooling_timer_timeout() -> void:
	raging = false
