extends CharacterBody2D


var max_health = 150.0
var health = max_health

#Movement and Vectors
var can_knockback: bool = false
var knockback_timer := 1.0
var repulsion_force := 300.0
var speed := 50
var base_speed = speed
var movement_stopper = Vector2.ZERO


#Negative Status
var can_debuff: bool = true

var slow_timer := 0.0
var snare_timer := 0.0
var bleed_timer := 0.0
var enemy_state = EnemyStateManager.EnemyDebuffStates.NO_BEBUFF


var is_slowed: bool = false
var is_bleeding: bool = false
var is_snared: bool = false


signal health_change

func _ready() -> void:
	pass


#Debuffs 
func apply_debuff(type, duration, multiplier, added_damage):
	
	if can_debuff and enemy_state == EnemyStateManager.EnemyDebuffStates.NO_BEBUFF:
		match type:
			'slow':
				is_slowed = true
				#print('is slowed? ', is_slowed)
				enemy_state = EnemyStateManager.EnemyDebuffStates.SLOWED
				#print(enemy_state, 'enemy state ')
				slow_timer = duration
				speed = base_speed * multiplier
			'bleed':
				is_bleeding = true
				print('is bleed? ', is_bleeding)
				enemy_state = EnemyStateManager.EnemyDebuffStates.BLEEDING
				#print(enemy_state, 'enemy state ')
				
				bleed_timer = duration
				health -= added_damage
			'snare':
				is_snared = true
				print('is snared? ', is_snared)
				enemy_state = EnemyStateManager.EnemyDebuffStates.SNARED
				#print(enemy_state, 'enemy state ')
				
				snare_timer = duration
				base_speed = movement_stopper
	
func handle_debuff(delta):
	
	if is_slowed:
		slow_timer -= delta 
		if slow_timer == 0:
			is_slowed = false
			slow_timer = 0 
			enemy_state = EnemyStateManager.EnemyDebuffStates.NO_BEBUFF
	if is_snared:
		snare_timer -= delta 
		if slow_timer == 0:
			is_slowed = false
			snare_timer = 0 
			enemy_state = EnemyStateManager.EnemyDebuffStates.NO_BEBUFF
	if is_bleeding:
		bleed_timer -= delta 
		if bleed_timer == 0:
			is_bleeding = false
			bleed_timer = 0 
			enemy_state = EnemyStateManager.EnemyDebuffStates.NO_BEBUFF

func apply_damage(damage):
	health -= damage
	print_debug(health)
	health = clamp(health, 0, 150.0)
	health_change.emit()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if not body: return
	
	var knockback_direction = (global_position - body.global_position).normalized()



func _on_hurtbox_area_entered(area: Area2D) -> void:
	var damage = 0
	if area.is_in_group('player_projectiles') and 'damage':
		damage = area.damage
	apply_damage(damage)
