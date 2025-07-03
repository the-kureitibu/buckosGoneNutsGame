extends CharacterBody2D

class_name EnemyParent

#Basic Info
var speed := 50.0
var original_speed := speed
var health: int
var avoid_radius := 70.0

#Extra Actions
var can_dash: bool = true
var is_dashing: bool = false
var dash_speed_multiplier = 5.0

#Statuses
var can_debuffed: bool = false
var is_snared: bool = false
var is_slowed: bool = false

#Status Durations
var snare_time_left := 0.0
var slow_time_left := 0.0
var slow_multiplier := 1.0

signal died
signal current_health(health_value)

@export var target_dir: Node2D

func hit(damage: int):

	health -= damage
	health = clamp(health, 0, 70)
	current_health.emit(health)
	#Globals.bucko.Health = 
	if health <= 0:
		die()

func snared(duration: float):
	if is_snared:
		return
	if can_debuffed:
		is_snared = true
		snare_time_left = duration
		set_physics_process(false) 


func slowed(multiplier: float, duration: float):
	if is_slowed:
		return
	if can_debuffed:
		is_slowed = true
		slow_time_left = duration
		slow_multiplier = multiplier
		speed = original_speed * multiplier

func _ready() -> void:
	set_physics_process(true)

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
		
		# Manually handle velocity here 
		velocity = final_dir * speed

		if is_dashing:
			velocity = final_dir * speed * dash_speed_multiplier
		else:
			velocity = final_dir * speed
		
		move_and_slide()
		
		look_at_target(final_dir)


func dash():
	if can_dash:
		is_dashing = true
		#Change animation 
		can_dash = false

func look_at_target(dir):
	if dir.length() > 0.1:
		rotation = dir.angle()
			
		# Play Animation as necessary
		#if is_dashing and $AnimationPlayer.current_animation != "bucko_dash":
			#$AnimationPlayer.play("bucko_dash")
		#elif !is_dashing and $AnimationPlayer.current_animation != "bucko_walk":
			#$AnimationPlayer.play("bucko_walk")
