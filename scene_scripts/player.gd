extends CharacterBody2D

#Movement
var speed := 100.0
var input := Vector2.ZERO
var repulsion_force := 300.0

#State and health 
var base_health = PlayerManager.player_health
var current_health = base_health
var is_invulnerable: bool = false
var is_bleeding: bool = false
var is_slowed: bool = false


#Timers 
var invulnerable_timer := 0.5
var attack_cd := 1.0



#Signals
signal launch_projectile(pos, dir)

func _ready() -> void:
	print(base_health, current_health)

func _get_input():
	input = Input.get_vector("left", "right", "top", "down")
	return input

func _physics_process(delta: float) -> void:
	_handle_movement()
	handle_attack()
	
	if is_invulnerable:
		invulnerable_timer -= delta
		if invulnerable_timer == 0:
			is_invulnerable = false

func _handle_movement():
	_get_input()
	velocity = input * speed
	move_and_slide()
	look_at(get_global_mouse_position())

	


func handle_attack():
	# instantiate projectile here 
	var projectile_direction = (get_global_mouse_position() - position).normalized()
	var projectile_position = $ProjectileMarker.global_position
	
	if Input.is_action_just_pressed("primary(mouse)"):
		launch_projectile.emit(projectile_position, projectile_direction)

#Health Stuff
func got_hit():
	if !is_invulnerable:
		is_invulnerable = true
		invulnerable_timer = 0.5
		
		if current_health == 0:
			die()


func die():
	pass


func _on_hurt_box_body_entered(body: Node2D) -> void:

	if not body: return
	
	var knockback_direction = (global_position - body.global_position).normalized()

	if 'can_knockback' in body:
		velocity = knockback_direction * repulsion_force

func _on_hurt_box_area_entered(area: Area2D) -> void:

	var damage = 0 

	if area.is_in_group('enemy_hurtbox'):
		var source_name = area.get_parent().name
		
		match source_name: 
			'Enemy':
				damage = EnemyManager.enemy_bucko.Damage
			'enemy_boss_one':
				damage = EnemyManager.enemy_boss1.Damage
			'enemy_boss_two':
				damage = EnemyManager.enemy_boss2.Damage
			'enemy_boss_three':
				damage = EnemyManager.enemy_boss3.Damage
	elif area.is_in_group('enemy_projectiles'):
		damage = area.damage

	got_hit()
	PlayerManager.apply_damage(damage)
	
	
