extends CharacterBody2D

@export var stats: EnemyStats
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var nav_target: Node2D
@onready var main_attack: PackedScene = preload("res://projectile_scenes/boss_two_projectile.tscn")

#Health Stuff
@onready var current_health = stats.base_health

#Movement and Vectors
var repulsion_force := 300.0
@onready var current_speed = stats.base_speed
var movement_stopper = Vector2.ZERO
var nav_timer := 0.5

#Attack Patterns
@onready var attack_state = EnemyStateManager.EnemyStates.CAN_ATTACK
var attack_cooldown := 5.0
var is_attacking: bool = false



#Signals
signal health_change(health)

#func _ready() -> void:
	#print(main_attack)


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

func handle_projectile_attack(delta):
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attacking = false
			attack_state = EnemyStateManager.EnemyStates.CAN_ATTACK
			attack_cooldown = 5.0
		return


	if attack_state == EnemyStateManager.EnemyStates.CAN_ATTACK and !is_attacking:
		is_attacking = true
		var projectile = main_attack.instantiate() as Area2D 
		projectile.follow_target = self

		get_tree().get_current_scene().get_node("Projectiles").add_child(projectile)
		attack_state = EnemyStateManager.EnemyStates.CANT_ATTACK



func _physics_process(delta: float) -> void:
	#nav_debug_label()
	handle_projectile_attack(delta)
	
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


func apply_damage(damage):
	current_health -= damage
	current_health = clamp(current_health, 0, 1500.0)
	health_change.emit(current_health)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	var damage = 0
	if area.is_in_group('player_projectiles') and 'damage':
		damage = area.damage

	apply_damage(damage)
