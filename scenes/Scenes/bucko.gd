extends EnemyParent



@export var buckoN: Sprite2D
@export var buckoD: Sprite2D
var velocity_stopper: Vector2 = Vector2.ZERO
var velocity_timer := 0.3
var has_just_dashed: bool = false
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D


func debug_label():
	var s: String = "Fin:%s\n" % nav_agent.is_navigation_finished()
	s += "reach:%s\n" % nav_agent.is_target_reachable()
	s += "reached:%s\n" % nav_agent.is_target_reached()
	s += "target:%s\n" % nav_agent.target_position
	$CanvasLayer/Label.text = s

func _ready() -> void:

	#set_physics_process(true)
	health = Globals.bucko.Health
	can_debuffed = true


func object_visibility(object):
	if object.visible == true:
		object.visible = false
	else:
		object.visible = true
		
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
		
			var dist_to_player = global_position.distance_to(target_dir.global_position)
			if dist_to_player < PLAYER_AVOID_RADIUS:
				var push = (global_position - target_dir.global_position).normalized()
				global_position += push * avoid * 0.5
		

		var final_dir = (target + avoid).normalized()
		
		if is_snared and can_debuffed:
			velocity = Vector2.ZERO
		else:
			_perform_attack_logic(delta, final_dir)
		# Manually handle velocity here 
		if is_dashing:
			velocity = final_dir * speed * dash_speed_multiplier
		elif !is_dashing and has_just_dashed:
			velocity = velocity_stopper
			velocity_timer -= delta
			if velocity_timer <= 0:
				velocity = final_dir * speed
				has_just_dashed = false
		else:
			if distance_to_target > PATH_MAX_DISTANCE:
				nav_agent.target_position = target_dir.global_position
				pathf_timer -= delta
				if pathf_timer <= 0: 
					pathf_timer = 0.2
			if nav_agent.is_navigation_finished():
				velocity = final_dir * speed
			else:
				var next_path_position = (nav_agent.get_next_path_position() - global_position).normalized()
				velocity = next_path_position * speed
			
		

			
		move_and_slide()
		
		look_at_target(final_dir)

func look_at_target(dir):
	if dir.length() > 0.1:
		rotation = dir.angle()
			
		# Play Animation as necessary
		if is_dashing and $AnimationPlayer.current_animation != "bucko_dash":
			$AnimationPlayer.play("bucko_dash")
		elif !is_dashing and $AnimationPlayer.current_animation != "bucko_walk":
			$AnimationPlayer.play("bucko_walk")


func _on_area_2d_body_entered(_body: Node2D) -> void:
	
	if can_dash:
		
		is_dashing = true
		object_visibility(buckoD)
		object_visibility(buckoN)
		can_dash = false
		$DashDisableTimer.start()
		

func _on_dash_disable_timer_timeout() -> void:
	$DashEnableTimer.start()
	object_visibility(buckoN)
	object_visibility(buckoD)
	is_dashing = false
	has_just_dashed = true


func _on_dash_enable_timer_timeout() -> void:
	can_dash = true


func _on_dmg_range_body_entered(body: Node2D) -> void:
	var damage = Globals.bucko.Damage

	if 'got_hit' in body:
		body.got_hit(damage)
