extends CharacterBody2D

#Basic Info
var speed = 50
var current_speed = speed
var can_dash: bool = true
var is_dashing: bool = false
var dash_speed_multiplier = 5.0
var health = Globals.bucko.Health
var avoid_radius := 32.0

#Statuses
var is_snared: bool = false
var is_slowed: bool = false

#temp
var snare_time_left := 0.0
var slow_time_left := 0.0
var slow_multiplier := 1.0

signal died

@export var buckoN: Sprite2D
@export var buckoD: Sprite2D
@export var target_dir: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func hit(damage: int):

	health -= damage
	health = clamp(health, 0, 70)
	#Globals.bucko.Health = 
	if health <= 0:
		die()

func snared(duration: float):
	if is_snared:
		return
	is_snared = true
	snare_time_left = duration
	set_physics_process(false) 
	
	#await get_tree().create_timer(duration).timeout

	set_physics_process(true) 
	is_snared = false

func slowed(multiplier: float, duration: float):
	if is_slowed:
		return
	is_slowed = true
	slow_time_left = duration
	slow_multiplier = multiplier
	#$NavigationAgent2D.max_speed *= multiplier
	#
	#await get_tree().create_timer(duration).timeout
#
	#$NavigationAgent2D.max_speed = speed
	is_slowed = false

func _ready() -> void:
	set_physics_process(true)
	make_path()

func die():
	set_physics_process(false)
	await get_tree().create_timer(0.1).timeout
	died.emit()
	queue_free()
	print('bucko died')



func _on_VisibilityNotifier2D_screen_exited():
	set_physics_process(false)

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)

#
func object_visibility(object):
	if object.visible == true:
		object.visible = false
	else:
		object.visible = true
	
func _physics_process(delta: float) -> void:
	#var direction = to_local(nav_agent.get_next_path_position()).normalized()
		# Handle snare temp
	if is_snared:
		snare_time_left -= delta
		if snare_time_left <= 0.0:
			is_snared = false
			set_physics_process(true)

	# Handle slow temp
	if is_slowed:
		slow_time_left -= delta
		if slow_time_left <= 0.0:
			is_slowed = false
			nav_agent.max_speed = speed

	#Temp steering 
	if target_dir:
		var target_dir = (target_dir.global_position - global_position).normalized()
		var avoid = Vector2.ZERO

		for other in get_tree().get_nodes_in_group("enemies"):
			if other == self:
				continue
			var dist = global_position.distance_to(other.global_position)
			if dist < avoid_radius:
				avoid += (global_position - other.global_position).normalized() / dist

		var final_dir = (target_dir + avoid).normalized()
		velocity = final_dir * speed
		move_and_slide()
		look_at(target_dir)


	#var next_path_position = nav_agent.get_next_path_position()
	#
	#var direction = (next_path_position - global_position).normalized()
	#if nav_agent.is_navigation_finished():
		#velocity = Vector2.ZERO
#
	#if is_dashing:
		#velocity = direction * $NavigationAgent2D.max_speed * dash_speed_multiplier
	#else:
		#velocity = direction * $NavigationAgent2D.max_speed
	#
	##var current_animation = $AnimatedSprite2D.animation
	#
	#if direction != Vector2.ZERO:
		#if is_dashing and $AnimationPlayer.current_animation != "bucko_dash":
			#$AnimationPlayer.play("bucko_dash")
		#elif !is_dashing and $AnimationPlayer.current_animation != "bucko_walk":
			#$AnimationPlayer.play("bucko_walk")
	#
	#move_and_slide()
	##if direction.length() > 0.1:
	#look_at(next_path_position)
	
func make_path():
	if target_dir and target_dir.is_inside_tree():
		nav_agent.target_position = target_dir.global_position
	else:
		print("Warning: target_dir is not valid or not in the scene tree.")

func _on_locate_timer_timeout() -> void:
	make_path()


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
