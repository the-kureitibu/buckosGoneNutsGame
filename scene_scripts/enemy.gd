extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var nav_target: Node2D
@export var stats: EnemyStats

#Health Stuff
@onready var current_health = stats.base_health

#Movement and Vectors
var can_knockback: bool = false
var knockback_timer := 1.0
var repulsion_force := 300.0
@onready var current_speed = stats.base_speed
var movement_stopper = Vector2.ZERO
var nav_timer := 0.5

#Attack Patterns
var can_dash: bool = true
var is_dashing: bool = false
var dash_timer := 0.3
var dash_cool_down := 7.0
var dash_range := 125.0
var dash_speed := 300.0


#Negative Statuses
var can_debuff: bool = true
var slow_timer := 0.0
var snare_timer := 0.0
var bleed_timer := 0.0
@onready var enemy_state = EnemyStateManager.EnemyDebuffStates.NO_DEBUFF
var is_slowed: bool = false
var is_bleeding: bool = false
var is_snared: bool = false

#Signals
signal health_change(health)

func _on_VisibilityNotifier2D_screen_exited():
	if global_position.distance_to(get_viewport().get_camera_2d().global_position) > 1000:
		queue_free()

#func _ready() -> void:

#Debug
func nav_debug_label():
	var s: String = "is reachable?:%s\n " % nav_agent.is_target_reachable()
	s += "is reached?:%s\n " % nav_agent.is_target_reached()
	s += "is finished?:%s\n " % nav_agent.is_navigation_finished()
	s += "is target:%s\n " % nav_agent.target_position
	$Label.text = s

func _physics_process(delta: float) -> void:
	#nav_debug_label()
	handle_debuff(delta)
	dash_handler(nav_target)

	if nav_target and nav_agent: 
		if is_dashing:
			var dash_direction = (nav_target.global_position - global_position).normalized()
			velocity = dash_direction * dash_speed
			dash_timer -= delta
			if dash_timer <= 0:
				is_dashing = false
				velocity = dash_direction * current_speed
					
			move_and_slide()
			return
		
		if !can_dash:
			dash_cool_down -= delta
			if dash_cool_down <= 0:
				can_dash = true
				dash_cool_down = 7.0
		
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

#Debuffs 
func apply_debuff(_type: String, duration: float, multiplier: float, added_damage: float):

	if can_debuff and enemy_state == EnemyStateManager.EnemyDebuffStates.NO_DEBUFF:
		if WeaponsManager.weapon_selected == "exchu":
			is_slowed = true
			enemy_state = EnemyStateManager.EnemyDebuffStates.SLOWED
			slow_timer = duration
			current_speed = stats.base_speed * multiplier
		if WeaponsManager.weapon_selected == "hanger":
			is_bleeding = true
			enemy_state = EnemyStateManager.EnemyDebuffStates.BLEEDING
			bleed_timer = duration
			current_health -= added_damage
		if WeaponsManager.weapon_selected == "embrace":
			is_snared = true
			enemy_state = EnemyStateManager.EnemyDebuffStates.SNARED
			snare_timer = duration
			current_speed = movement_stopper
	
func handle_debuff(delta):
	
	if is_slowed:
		slow_timer -= delta 
		if slow_timer <= 0:
			is_slowed = false
			slow_timer = 0 
			current_speed = stats.base_speed
			enemy_state = EnemyStateManager.EnemyDebuffStates.NO_DEBUFF
	if is_snared:
		snare_timer -= delta 
		if snare_timer <= 0:
			is_snared = false
			snare_timer = 0 
			current_speed = stats.base_speed
			enemy_state = EnemyStateManager.EnemyDebuffStates.NO_DEBUFF
	if is_bleeding:
		bleed_timer -= delta 
		if bleed_timer <= 0:
			is_bleeding = false
			bleed_timer = 0 
			enemy_state = EnemyStateManager.EnemyDebuffStates.NO_DEBUFF

func apply_damage(damage):
	current_health -= damage
	current_health = clamp(current_health, 0, 150.0)
	health_change.emit(current_health)

#Attacks 
func dash_handler(target: Node2D):
	if !can_dash:
		return
	
	if global_position.distance_to(target.global_position) <= dash_range:
		is_dashing = true
		can_dash = false
		dash_timer = 0.3


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if not body: return
	
	#var knockback_direction = (global_position - body.global_position).normalized()
#

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var damage = 0
	if area.is_in_group('player_projectiles') and 'damage':
		damage = area.damage

	apply_damage(damage)
