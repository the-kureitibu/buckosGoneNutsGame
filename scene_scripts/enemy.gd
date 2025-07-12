extends CharacterBody2D

var repulsion_force := 300.0

var can_knockback := false
var knockback_timer := 1.0
var max_health = 150.0
var health = max_health

signal health_change


func apply_damage(damage):
	health -= damage
	print_debug('damage: ', damage)
	print_debug(health)
	health = clamp(health, 0, 150.0)
	health_change.emit()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if not body: return
	
	var knockback_direction = (global_position - body.global_position).normalized()
	var damage = 0
#
	##projectiles here
	#if body.is_in_group('player'):
		#damage = EnemyManager.enemy_bucko.Damage
	#
	#EnemyManager.apply_damage(damage, health, max_health)
	#if player_hurtbox


func _on_hurtbox_area_entered(area: Area2D) -> void:
	var damage = 0
	if area.is_in_group('player_projectiles') and 'damage':
		damage = area.damage
	print(damage)
	apply_damage(damage)
