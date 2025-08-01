extends CharacterBody2D


@export var stats: EnemyStats
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var nav_target: Node2D
@export var chain_getter: ProjectileAttacks
@onready var pop_up: PackedScene = preload("res://ui_scenes/pop_up_damage.tscn")
#@onready var main_attack: PackedScene = preload("res://projectile_scenes/chain_projectile.tscn")
var middle_chain: PackedScene = preload("res://projectile_scenes/chain_projectile_mid.tscn")
var main_attack: PackedScene


#Health Stuff
@onready var current_health = stats.base_health
var snared_invul_timer := 1.0
var damaged_state = EnemyStateManager.EnemyStates.IDLE


#Movement and Vectors
var repulsion_force := 300.0
@onready var current_speed = stats.base_speed
var movement_stopper = Vector2.ZERO
var nav_timer := 0.5
var damage = 20


#Attack Patterns
@onready var attack_state = EnemyStateManager.EnemyStates.CAN_ATTACK
var attack_cooldown := 5.0
var is_attacking: bool = false

#Signals
signal health_change(health)
signal death

func _ready() -> void:
	main_attack = chain_getter.chain_attack["base"]


func _on_VisibilityNotifier2D_screen_exited():
	if global_position.distance_to(get_viewport().get_camera_2d().global_position) > 1000:
		queue_free()


#Debug
func nav_debug_label():
	var s: String = "is reachable?:%s\n " % nav_agent.is_target_reachable()
	s += "is reached?:%s\n " % nav_agent.is_target_reached()
	s += "is finished?:%s\n " % nav_agent.is_navigation_finished()
	s += "is target:%s\n " % nav_agent.target_position
	$Label.text = s

#Attacks

#func launch_straight_attack():
	#var straight_attack = [
	#$AttackMarker/SAttack1,
	#$AttackMarker/SAttack2
#]
	#for marker in straight_attack:
		#launch_chains(marker)

#
#func launch_cone_attack():
	#
	##for marker in cone_attack:
	#launch_chains(cone_attack[1])


func launch_chains():
	if attack_state == EnemyStateManager.EnemyStates.CAN_ATTACK and !is_attacking:
		is_attacking = true
		attack_state = EnemyStateManager.EnemyStates.CANT_ATTACK

		#projectile.follow_target = $AttackMarker
		var markers = [
			$AttackMarker/fCone1,
			$AttackMarker/fCone2,
			$AttackMarker/fCone3
		]
		
		for m in markers:
			var projectile = main_attack.instantiate() as Area2D 
			get_tree().get_current_scene().get_node("Projectiles").add_child(projectile)
			projectile.global_position = m.global_position 
			projectile.start_extending_chain(m, nav_target)
		
		await get_tree().create_timer(2.5).timeout
		
		var straight_attack = [
			$AttackMarker/SAttack1,
			$AttackMarker/SAttack2
			]
		
		for s in straight_attack:
			var projectile = main_attack.instantiate() as Area2D 
			get_tree().get_current_scene().get_node("Projectiles").add_child(projectile)
			projectile.global_position = s.global_position 
			projectile.start_extending_chain(s, nav_target)
		#marker is also a Marker2d
		 #Added here so the base always follow the marker when boss is moving
		
		
		
		#await get_tree().create_timer(2.0).timeout
		#projectile.extend_chain(middle_chain, marker.global_position)

	

func handle_projectile_attack(delta):
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attacking = false
			attack_state = EnemyStateManager.EnemyStates.CAN_ATTACK
			attack_cooldown = 5.0
		return

	launch_chains()
	#if attack_state == EnemyStateManager.EnemyStates.CAN_ATTACK and !is_attacking:
		#is_attacking = true
		#var projectile = main_attack.instantiate() as Area2D 
		#projectile.follow_target = $AttackMarker/SAttack1 #< this throws the error
#
		#get_tree().get_current_scene().get_node("Projectiles").add_child(projectile)
		#attack_state = EnemyStateManager.EnemyStates.CANT_ATTACK



func _physics_process(delta: float) -> void:
	#nav_debug_label()
	handle_projectile_attack(delta)
	
	if damaged_state == EnemyStateManager.EnemyStates.ATTACKED:
		snared_invul_timer -= delta
		if snared_invul_timer <= 0:
			damaged_state = EnemyStateManager.EnemyStates.IDLE
			snared_invul_timer = 1.0
	
	
	
	if !nav_target:
		print('no target')
		return
	
	
	if nav_target and nav_agent: 
		
		nav_agent.target_position = nav_target.global_position
		var avoid_force = Vector2.ZERO
		const AVOID_RADIUS = 30.0
		
		for other in get_tree().get_nodes_in_group('enemy_hurtbox'):
			if other == self:
				continue
			var distance_from_other = global_position.distance_to(other.global_position)
			if distance_from_other < AVOID_RADIUS:
				avoid_force += (global_position - other.global_position).normalized() / distance_from_other
			
		#var final_target = (nav_target.global_position - global_position).normalized()
		#var final_dir = (nav_target.global_position + avoid_force).normalized()
	
		if !nav_agent.is_navigation_finished():
			var next_dir = (nav_agent.get_next_path_position() - global_position).normalized()
			nav_timer -= delta
			if nav_timer == 0:
				nav_timer = 0.5
			velocity = next_dir * current_speed
		elif nav_agent.is_navigation_finished():
			nav_agent.max_speed = 0
			await get_tree().create_timer(0.5).timeout
			nav_agent.get_next_path_position()
		
			
	move_and_slide()
	look_at(nav_target.global_position)


func apply_damage(dmg, area: Area2D):
	if damaged_state == EnemyStateManager.EnemyStates.ATTACKED:
		return
	
	damaged_state = EnemyStateManager.EnemyStates.ATTACKED
	
	
	if area.is_in_group('player_projectiles'):
		var popup = pop_up.instantiate()
		get_tree().current_scene.add_child(popup)
		popup.position = $popup.global_position
		popup._show_damage(dmg, false)
		
	current_health -= dmg
	current_health = clamp(current_health, 0, 2100.0)
	health_change.emit(current_health)

	
	if current_health <= 0:
		die()

func die():
	if EnemyStateManager.boss_state == EnemyStateManager.EnemyStates.BOSS_DEATH:
		return
	
	EnemyStateManager.boss_state = EnemyStateManager.EnemyStates.BOSS_DEATH
	death.emit()
	queue_free()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var dmg = 0
	if area.is_in_group('player_projectiles') and 'damage':
		dmg = area.damage

	apply_damage(dmg, area)
