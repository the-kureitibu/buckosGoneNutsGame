extends CharacterBody2D

@onready var transition = $CanvasLayer/Transition/ColorRect/AnimationPlayer

#General movement related
var max_speed: int = 120
var base_speed = max_speed
const acceleration := 350
const friction := 400
var input: Vector2 = Vector2.ZERO


#Status Debuffed
var can_be_debuffed: bool = true 
var is_slowed: bool = false 
var slow_multiplier: float = 0.0
var slow_timer: float = 0.0
var invulnerable_timer := 0.5
var is_invulnerable: bool = false

signal projectle(pos, direction)
signal current_health(health_value)
signal damage_received(damage)

#Rage stuff 
@onready var rage_timer = $RageTimer
@onready var rage_timer2 = $RageTimer2
@onready var label = $Label
var time_elapsed = 0


func _ready():
	
	Globals.rage_activated.connect(start_rage_timer)
	Globals.player_state = Globals.PlayerState.CAN_ATTACK
	
func start_rage_timer():
	if Globals.rage_on != false and time_elapsed != 15 and Globals.rage_state == Globals.RageState.IDLE: 
		if not rage_timer.is_connected("timeout", on_timer_timeout):
			rage_timer.timeout.connect(on_timer_timeout)
			rage_timer.start()
			Globals.rage_state = Globals.RageState.RAGING
			Globals.rage_stats = Globals.RageStat.RAGE_ON

func second_rage_timer():
	if not rage_timer2.is_connected("timeout", second_timer_timeout):
		rage_timer2.timeout.connect(second_timer_timeout)
		rage_timer2.start()
	
func second_timer_timeout():
	Globals.rage -= 3 
	if Globals.rage == 0:
		rage_timer2.stop()
		Globals.rage_state = Globals.RageState.IDLE
		rage_timer2.disconnect("timeout", second_timer_timeout)
	
func on_timer_timeout():
	time_elapsed += 1
	
	if time_elapsed == 5:
		Globals.rage_state = Globals.RageState.COOLDOWN
		Globals.rage_stats = Globals.RageStat.COOLING_DOWN
	elif time_elapsed == 8:
		Globals.rage_stats = Globals.RageStat.RAGE_OFF
	elif time_elapsed == 15: 
		rage_timer.stop()
		time_elapsed = 0
		second_rage_timer()
		Globals.rage_on = false
		Globals.rage_state = Globals.RageState.RAGEDONE
		rage_timer.disconnect("timeout", on_timer_timeout)


func got_hit(damage):
	#var health = Globals.ami_health
	if !is_invulnerable:
		is_invulnerable = true
		Globals.ami_health -= damage
		Globals.ami_health = clamp(Globals.ami_health, 0, 250)
		current_health.emit(Globals.ami_health)
		damage_received.emit(damage)
		if Globals.ami_health <= 0:
			die()

func die():
	transition.play("fade_in")
	# this produces bugs
	#Globals.reset_all()
	#DialogueStates.reset_all()
	await transition.animation_finished
	get_tree().change_scene_to_file("res://scenes/screens_and_dialogues/starting_menu.tscn")

func slowed(multiplier, duration):
	if is_slowed:
		return
	is_slowed = true
	if is_slowed and can_be_debuffed:
		slow_timer = duration
		max_speed = base_speed * multiplier
		


func _physics_process(delta):
	
	if is_invulnerable: 
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			is_invulnerable = false

	
	if is_slowed:
		slow_timer -= delta
		if slow_timer <= 0: 
			is_slowed = false
			max_speed = base_speed
	
	if $AmiBase.visible == true:
		$AnimationPlayer.play("ami_base")
	
	player_movement(delta)

	# player idle selection after button clicked 
	# try object != object as refactor
	if Globals.wep_embrace == true:
		$AmiEmbrace.visible = true
		$AmiBase.visible = false
	elif Globals.wep_hanger == true:
		$AmiHanger.visible = true
		$AmiBase.visible = false
	elif Globals.wep_exchu == true:
		$AmiExchu.visible = true
		$AmiBase.visible = false
	
	if Input.is_action_just_pressed("primary(mouse)"):
		#print("Mouse click detected.")
		#print("Player State: ", Globals.player_state)
		if Globals.player_state == Globals.PlayerState.CAN_ATTACK or Globals.player_state == Globals.PlayerState.IDLE:
			#print("Attack allowed.")
			$AttackTimer.start()
			player_attack()
			Globals.player_state = Globals.PlayerState.CANT_ATTACK
		elif Globals.rage_state == Globals.RageState.RAGING or Globals.rage_state == Globals.RageState.COOLDOWN:
			#print("Rage state override.")
			player_attack()

func get_input():
	input = Input.get_vector("left", "right", "top", "down")
	return input

func player_movement(delta):
	input = get_input()
	
	#Accelerated movement code
	#velocity = input * max_speed
	#
	#if input == Vector2.ZERO: #when not moving but previously moving
		#if velocity.length() > (friction * delta): # when not moving but previously moving, and there is a remaining velocity (greater than the value of friction )
			#velocity -= velocity.normalized() * (friction * delta) # then slowly reduce by the normalized value of velocity (1) * delta
		#else:
			#velocity = Vector2.ZERO #else, stop moving
	#else:
	
	#Base movement 
	velocity = input * max_speed  #if there is a movement, move based on accelaration and input * delta
	#velocity = velocity.limit_length(max_speed) #limits max accelaration
		
	move_and_slide()

	look_at(get_global_mouse_position()) #for mouse dedicated game only
	

func player_attack():
	var player_direction = (get_global_mouse_position() - position).normalized() #projectile start
	
	#Animation stuff and weapon selection stuff 
	if Globals.wep_hanger == true:
		$AnimationPlayer.play("ami_hanger")
	elif Globals.wep_embrace == true:
		$AnimationPlayer.play("ami_embrace")
	elif Globals.wep_exchu == true:
		$AnimationPlayer.play("ami_exchu")
		
	var proj_marker = $AmiBase/Marker2D.global_position
	projectle.emit(proj_marker, player_direction)

	# send a signal to main level if trigger is pulled, mainly pos and direction 

func _on_attack_timer_timeout() -> void:
	if Globals.player_state == Globals.PlayerState.CANT_ATTACK:
		Globals.player_state = Globals.PlayerState.CAN_ATTACK # Replace with function body.
