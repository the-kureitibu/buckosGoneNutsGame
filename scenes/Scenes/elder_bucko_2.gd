extends EnemyParent

@onready var e2_proj: PackedScene = preload("res://projectiles/elder2_proj.tscn")

func _ready() -> void:
	proj_scene = e2_proj
	
	current_attack_timer = attack_startup
	can_attack = true
	health = Globals.elder_bucko2.Health
	avoid_radius = 75.0

	#I'm trying to figure out how to modify this code from the parent
func projectile(delta):
	#var follow_target = self
	
	var wep = proj_scene.instantiate() as Area2D
	wep.follow_target = self

	get_parent().add_child(wep)

func _perform_attack_logic(delta: float, direct: Vector2):
	handle_attack_logic(delta, direct)

	#I'm trying to figure out how to modify this code from the parent
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
		



func hit(damage: int):

	health -= damage
	health = clamp(health, 0, 600)
	current_health.emit(health)
	#Globals.bucko.Health = 
	if health <= 0:
		die()

func look_at_target(dir):
	if dir.length() > 0.1:
		rotation = dir.angle()
	$AnimationPlayer.play("bucko_walk")
