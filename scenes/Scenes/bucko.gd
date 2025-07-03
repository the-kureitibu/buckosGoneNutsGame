extends EnemyParent



@export var buckoN: Sprite2D
@export var buckoD: Sprite2D


func _ready() -> void:
	set_physics_process(true)
	health = Globals.bucko.Health
	can_debuffed = true

func object_visibility(object):
	if object.visible == true:
		object.visible = false
	else:
		object.visible = true
	
#func _physics_process(delta: float) -> void:
	## Handle snare temp
	#if is_snared:
		#snare_time_left -= delta
		#if snare_time_left <= 0.0:
			#is_snared = false
			#set_physics_process(true)
#
	## Handle slow temp
	#if is_slowed:
		#slow_time_left -= delta
		#if slow_time_left <= 0.0:
			#is_slowed = false
			#speed = original_speed
#
	##Temp steering 
#
	#
	#if target_dir:
		#var target = (target_dir.global_position - global_position).normalized()
		#var avoid = Vector2.ZERO
#
		#for other in get_tree().get_nodes_in_group("enemies"):
			#if other == self:
				#continue
			#var dist = global_position.distance_to(other.global_position)
			#if dist < avoid_radius:
				#avoid += (global_position - other.global_position).normalized() / dist
#
		#var final_dir = (target + avoid).normalized()
		#velocity = final_dir * speed
		#
		#
		#if is_dashing:
			#velocity = final_dir * speed * dash_speed_multiplier
		#else:
			#velocity = final_dir * speed
		#
		#move_and_slide()
		#
		#if final_dir.length() > 0.1:
			#rotation = final_dir.angle()
			#
			#if is_dashing and $AnimationPlayer.current_animation != "bucko_dash":
				#$AnimationPlayer.play("bucko_dash")
			#elif !is_dashing and $AnimationPlayer.current_animation != "bucko_walk":
				#$AnimationPlayer.play("bucko_walk")

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

func _on_dash_enable_timer_timeout() -> void:
	can_dash = true
