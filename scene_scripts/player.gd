extends CharacterBody2D

#Movement
var speed := 150.0
var input := Vector2.ZERO
var repulsion_force := 300.0

#State and health 
var base_health = PlayerManager.player_health
var current_health = base_health
var is_invulnerable: bool = false
var is_bleeding: bool = false
var is_slowed: bool = false
var is_knockback: bool = false
var current_state = PlayerStateManager.PlayerState.IDLE
var attack_speed: float

#Timers 
var invulnerable_timer := 0.5
var attack_cd := 1.25
var current_attack_speed = attack_cd

#Signals
signal launch_projectile(pos, dir)

func _ready() -> void:
	current_state = PlayerStateManager.PlayerState.CAN_ATTACK
	


func weapon_setter():
	if WeaponsManager.exchulibladder:
		attack_speed = WeaponsManager.exchu_projectile.Attack_speed
		current_attack_speed = attack_cd - attack_speed
		print('current atk spd: ', current_attack_speed)
	if WeaponsManager.hanger:
		attack_speed = WeaponsManager.hanger_projectile.Attack_speed
		current_attack_speed = attack_cd - attack_speed
		print('current atk spd: ', current_attack_speed)
	if WeaponsManager.embrace:
		attack_speed = WeaponsManager.embrace_projectile.Attack_speed
		current_attack_speed = attack_cd - attack_speed
		print('current atk spd: ', current_attack_speed)


func _get_input():
	input = Input.get_vector("left", "right", "top", "down")
	return input

func _physics_process(delta: float) -> void:
	_handle_movement()
	handle_attack(delta)
	
	if is_invulnerable:
		invulnerable_timer -= delta
		if invulnerable_timer == 0:
			is_invulnerable = false

func _handle_movement():
	_get_input()
	velocity = input * speed
	if !is_knockback:
		move_and_slide()
	
	look_at(get_global_mouse_position())



func handle_attack(delta):
	# instantiate projectile here 
	var projectile_direction = (get_global_mouse_position() - position).normalized()
	var projectile_position = $ProjectileMarker.global_position
	
	if current_state == PlayerStateManager.PlayerState.CAN_ATTACK:
		if Input.is_action_just_pressed("primary(mouse)"):
			launch_projectile.emit(projectile_position, projectile_direction)
			current_state == PlayerStateManager.PlayerState.CANT_ATTACK
			current_attack_speed -= delta
			if current_attack_speed <= 0:
				current_state == PlayerStateManager.PlayerState.CAN_ATTACK
				current_attack_speed = attack_cd - attack_speed

#Health Stuff
func got_hit():
	if !is_invulnerable:
		is_invulnerable = true
		invulnerable_timer = 0.5
		
		if current_health == 0:
			die()

func die():
	pass

func got_knockbacked(source: Node2D, force: float):
	if is_knockback:
		return
	
	if !is_knockback:
		is_knockback = true
		velocity = (global_position - source.global_position).normalized() * force
		move_and_slide()
		
		Engine.time_scale = 0.3
		await get_tree().create_timer(0.08).timeout
		Engine.time_scale = 1.0

		await get_tree().create_timer(0.2).timeout
		is_knockback = false
		
		
func _on_hurt_box_body_entered(body: Node2D) -> void:

	if not body: return
	
	var knockback_direction = (global_position - body.global_position).normalized()

	if 'can_knockback' in body:
		velocity = knockback_direction * repulsion_force
		

func _on_hurt_box_area_entered(area: Area2D) -> void:

	var damage = 0 

	if area.is_in_group('enemy_hurtbox'):
		var source_name = area.get_parent().name
		var source = area.get_parent()
		var method_getter = area.get_parent().has_method('dash_handler')
		
		match source_name: 
			'Enemy':
				damage = EnemyManager.enemy_bucko.Damage
			'enemy_boss_one':
				damage = EnemyManager.enemy_boss1.Damage
			'enemy_boss_two':
				damage = EnemyManager.enemy_boss2.Damage
			'enemy_boss_three':
				damage = EnemyManager.enemy_boss3.Damage
				
		if source.is_dashing:
			var knockback_strengh := 600.0
			got_knockbacked(source, knockback_strengh)
			
			
	elif area.is_in_group('enemy_projectiles'):
		damage = area.damage

	got_hit()
	PlayerManager.apply_damage(damage)
	
	
