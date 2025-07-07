extends EnemyParent

var base_speed := speed
@onready var e1_proj: PackedScene = preload("res://projectiles/elder_proj.tscn")
#@onready var damage_pop_up = preload("res://scenes/u_i/enemy_damage_popup.tscn")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	#nav_agent = $NavigationAgent2D
	proj_scene = e1_proj
	current_attack_timer = attack_startup
	can_attack = true
	#if can_attack:
		#$AnimationPlayer.play("charge")
	#else:
		#$Sprite2D2.visible = false
		
	health = Globals.elder_bucko1.Health
	avoid_radius = 75.0

func _physics_process(delta: float) -> void:
	if nav_agent == null:
		print("⚠️ nav_agent is NULL!")
	
	var distance_to_target = global_position.distance_to(target_dir.global_position)
	# Handle snare temp
		
	if is_snared:
		snare_time_left -= delta
		if snare_time_left <= 0.0:
			is_snared = false


	# Handle slow temp
	if is_slowed:
		slow_time_left -= delta
		if slow_time_left <= 0.0:
			is_slowed = false
			speed = original_speed

	#Temp steering 

	if target_dir:
		var target = (target_dir.global_position - global_position).normalized()
		var avoid = Vector2.ZERO

		for other in get_tree().get_nodes_in_group("enemies"):
			if other == self:
				continue
			var dist = global_position.distance_to(other.global_position)
			if dist < avoid_radius:
				avoid += (global_position - other.global_position).normalized() / dist
			

		var final_dir = (target + avoid).normalized()
		
		if is_snared and can_debuffed:
			velocity = Vector2.ZERO
		else:
			_perform_attack_logic(delta, final_dir)
		# Manually handle velocity here 
			if is_dashing:
				velocity = final_dir * speed * dash_speed_multiplier
			else:
				velocity = final_dir * speed
			
		
		if distance_to_target > PATH_MAX_DISTANCE:
			nav_agent.target_position = target_dir.global_position
			pathf_timer -= delta
			if pathf_timer <= 0: 
				pathf_timer = 0.2

		if nav_agent.is_navigation_finished():
			velocity = final_dir * speed
		else:
			var next_path_position = nav_agent.get_next_path_position().normalized()
			velocity = next_path_position * speed
			
		move_and_slide()
		
		look_at_target(final_dir)

func _perform_attack_logic(delta: float, direct: Vector2):


	handle_attack_logic(delta, direct)
	

func hit(damage: int):

	health -= damage
	health = clamp(health, 0, 500)
	current_health.emit(health)
	_spawn_dmg_text(damage)
	#Globals.bucko.Health = 
	if health <= 0:
		die()

func look_at_target(dir):
	if dir.length() > 0.1:
		rotation = dir.angle()
	$AnimationPlayer.play("elder_bucko_walk")


func _spawn_dmg_text(damage):
	var popup = dmgpop_up.instantiate() 

	#var popup_start_pos = $InGameUI.get_global_position()
	popup.global_position = self.get_global_position()

	
	get_tree().current_scene.add_child(popup)
	popup.show_damage(damage)




#func _on_current_health(health_value: Variant) -> void:
	#pass # Replace with function body.
#
#
#func _on_timer_timeout() -> void:
	#Globals.can_attack = true
	#
