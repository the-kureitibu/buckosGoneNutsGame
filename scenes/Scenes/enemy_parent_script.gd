extends CharacterBody2D

class_name EnemyParent

#Basic Info
var speed := 50.0
var original_speed := speed
var health: int
var avoid_radius := 70.0
var movement_stopper: Vector2 = Vector2.ZERO
var speed_reduc_multiplier := 0.1

#Attack Related States
var can_attack: bool = false
var is_in_startup := true
var is_in_cooldown := false
var attack_startup := 1.5
var attack_cooldown := 5.0
var current_attack_timer := 0.0

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
@export var proj_scene: PackedScene

#This is my function to delay the movement, and then shoots after 
func handle_attack_logic(delta, direct):
	
	if is_in_startup:
		current_attack_timer -= delta
		if current_attack_timer <= 0:
			projectile(delta)
			current_attack_timer = attack_cooldown
			is_in_cooldown = true
			print_debug('cd', is_in_cooldown)
			is_in_startup = false
			print_debug('sup', is_in_startup)
			#is_in_startup = false
			
	elif is_in_cooldown: 
		current_attack_timer -= delta
		if current_attack_timer <= 0:
			is_in_cooldown = false
			print_debug(is_in_cooldown, 'cd')
			can_attack = true
			print_debug(can_attack)

	elif can_attack:
		current_attack_timer = attack_startup
		is_in_startup = true
		can_attack = false
		

	
	#if can_attack: 
		#print_debug('can attack?', can_attack)
		#current_attack_timer -= delta
		#projectile(delta)
		##can_attack = false
		#velocity = movement_stopper
		#if current_attack_timer <= 0:
			#velocity = direct * speed 
			#print_debug('can attack?', can_attack)
			#current_attack_timer = attack_cooldown
			#print_debug('timer rn', current_attack_timer)
			#
	#current_attack_timer -= delta
	##Override function in child
	##if can attack 
		##projectile
		##set timer to 1.5 
		##stop movement 
		##set attack to false 
		##back movement 
	#

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
		
		_perform_attack_logic(delta, final_dir)
		# Manually handle velocity here 
		velocity = final_dir * speed
		
		#This line seems to run according to breakpoints, but it never activates the projectile function inside
		
		
		if is_dashing:
			velocity = final_dir * speed * dash_speed_multiplier
		else:
			velocity = final_dir * speed
		
		move_and_slide()
		
		look_at_target(final_dir)

func _perform_attack_logic(delta: float, direct: Vector2):
	pass

func projectile(delta):

	# Implement Slow before fully attacking 
		#use Animation and function 
		#slow moving when projectile 
		#make sure to increase speed 
		#implement split attack
	# Fix Timer and use delta instead 
	# fix status change of can attack 
	# change z index of projectile on top of health bar 
	if target_dir:
		var target = (target_dir.global_position - global_position).normalized()
		var p1_pos = $Marker2D
		
		var wep = proj_scene.instantiate() as Area2D
		wep.position = p1_pos.global_position
		wep.direction = target
		wep.rotation = target.angle()
		get_tree().current_scene.get_node("Projectiles").add_child(wep)
		

		#set timer to cooldown attack
		#set can attack to true
		#current_attack_timer -= delta
		#print_debug('timer rn', current_attack_timer)
		#if current_attack_timer <= 0:
			##is_in_startup = true
			#can_attack = true
			#print_debug('can attack?', can_attack)

func dash():
	if can_dash:
		is_dashing = true
		#Change animation 
		can_dash = false

func look_at_target(dir):
	if dir.length() > 0.1:
		rotation = dir.angle()
			
		# Play Animation as necessary
